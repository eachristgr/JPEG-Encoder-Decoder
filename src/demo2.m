%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 2 - JPEG Intergration
% 2.3 Demo 2

clear all;
clc;

%% Tables Initializations
qTableL = [  16  11  10  16  24  40  51  61  ;
             12  12  14  19  26  58  60  55  ;
             14  13  16  24  40  57  69  56  ;
             14  17  22  29  51  87  80  62  ;
             18  22  37  56  68  109 103 77  ;
             24  35  55  64  81  104 113 92  ;
             49  64  78  87  103 121 120 101 ;
             72  92  95  98  112 100 103 99  ];
    
% Table K2 – Chrominance quantization table
qTableC = [  17	18	24	47	99	99	99	99  ;
             18	21  26  66  99  99  99  99  ;
             24	26  56  99  99  99  99  99  ;
             47	66  99  99  99  99  99  99  ;
             99	99  99  99  99  99  99  99  ;
             99	99  99  99  99  99  99  99  ;
             99	99  99  99  99  99  99  99  ;
             99	99  99  99  99  99  99  99  ];

%% Load Images
load('img1_down.mat');
imageRGB1 = img1_down;
load('img2_down.mat');
imageRGB2 = img2_down;

%% Entropy Measurement - Spatial Domain
% Image 1 - R
R1 = imageRGB1(:,:,1);
freq = histc(R1(:), unique(R1(:)));
p = freq / sum(freq);
entrR1 = - sum(p .* log(p)/log(2));
% Image 1 - G
G1 = imageRGB1(:,:,2);
freq = histc(G1(:), unique(G1(:)));
p = freq / sum(freq);
entrG1 = - sum(p .* log(p)/log(2));
% Image 1 - B
B1 = imageRGB1(:,:,3);
freq = histc(B1(:), unique(B1(:)));
p = freq / sum(freq);
entrB1 = - sum(p .* log(p)/log(2));
% Save Entropies
SDentropy1 = [entrR1, entrG1, entrB1];

% Image 2 - R
R2 = imageRGB2(:,:,1);
freq = histc(R2(:), unique(R2(:)));
p = freq / sum(freq);
entrR2 = - sum(p .* log(p)/log(2));
% Image 2 - G
G2 = imageRGB2(:,:,2);
freq = histc(G2(:), unique(G2(:)));
p = freq / sum(freq);
entrG2 = - sum(p .* log(p)/log(2));
% Image 2 - B
B2 = imageRGB2(:,:,3);
freq = histc(B2(:), unique(B2(:)));
p = freq / sum(freq);
entrB2 = - sum(p .* log(p)/log(2));
% Save Entropies
SDentropy2 = [entrR2, entrG2, entrB2];

%% Convert to YCbCr
subimg1 = [4 2 2];	% image 1 : RGB -> YCbCr 4:2:2
[Y1, Cb1, Cr1] = convert2ycbcr(imageRGB1, subimg1);
subimg2 = [4 4 4];	% image 2 : RGB -> YCbCr 4:4:4
[Y2, Cb2, Cr2] = convert2ycbcr(imageRGB2, subimg2);

%% RGB -> YCbCr -> DCT -> Quantization -> qDCT compoments
qScale1 = 0.6;  % image 1 : qScale = 0.6
qScale2 = 5;    % image 2 : qScale = 5

% Luminance (Y) compoment
qTable = qTableL;
DCpredY1 = 0;
dctBlocksY1 = zeros(0,8);
SymbolsY1 = zeros(0,2);
for i = 0:8:(size(Y1, 1)-8)+1
    for j = 0:8:(size(Y1, 2)-8)+1
        % Create blocks
        blockY1 = Y1(i+1:i+8, j+1:j+8);
        % DCT transform 
        dctBlockY1 = blockDCT(blockY1);  
        % Quantization
        qBlockY1 = quantizeJPEG(dctBlockY1, qTable, qScale1);
        % Entropy Measurement - qDCT
        dctBlocksY1 = cat(1, dctBlocksY1, qBlockY1); 
        % ZigZag
        runSymbolsY1 = runLength(qBlockY1, DCpredY1);
        DCpredY1 = runSymbolsY1(1, 2);
        % Entropy Measurement - Run Length
        SymbolsY1 = cat(1, SymbolsY1, runSymbolsY1);
    end
end
DCpredY2 = 0;
dctBlocksY2 = zeros(0,8);
SymbolsY2 = zeros(0,2);
for i = 0:8:(size(Y2, 1)-8)+1
    for j = 0:8:(size(Y2, 2)-8)+1
        % Create blocks
        blockY2 = Y2(i+1:i+8, j+1:j+8);
        % DCT transform 
        dctBlockY2 = blockDCT(blockY2);  
        % Quantization
        qBlockY2 = quantizeJPEG(dctBlockY2, qTable, qScale2);
        % Entropy Measurement - qDCT
        dctBlocksY2 = cat(1, dctBlocksY2, qBlockY2); 
        % ZigZag
        runSymbolsY2 = runLength(qBlockY2, DCpredY2);
        DCpredY2 = runSymbolsY2(1, 2);
        % Entropy Measurement - Run Length
        SymbolsY2 = cat(1, SymbolsY2, runSymbolsY2);
    end
end

% Chrominance (Cb, Cr) compoments
qTable = qTableC;
DCpredCb1 = 0;
dctBlocksCb1 = zeros(0,8);
SymbolsCb1 = zeros(0,2);
DCpredCr1 = 0;
dctBlocksCr1 = zeros(0,8);
SymbolsCr1 = zeros(0,2);
for i = 0:8:(size(Cb1, 1)-8)+1
    for j = 0:8:(size(Cb1, 2)-8)+1
        % Create blocks
        blockCb1 = Cb1(i+1:i+8, j+1:j+8);
        blockCr1 = Cr1(i+1:i+8, j+1:j+8);
        % DCT transform 
        dctBlockCb1 = blockDCT(blockCb1);  
        dctBlockCr1 = blockDCT(blockCr1);
        % Quantization
        qBlockCb1 = quantizeJPEG(dctBlockCb1, qTable, qScale1);
        qBlockCr1 = quantizeJPEG(dctBlockCr1, qTable, qScale1);
        % Entropy Measurement - qDCT
        dctBlocksCb1 = cat(1, dctBlocksCb1, qBlockCb1);
        dctBlocksCr1 = cat(1, dctBlocksCr1, qBlockCr1);
        % ZigZag
        runSymbolsCb1 = runLength(qBlockCb1, DCpredCb1);
        DCpredCb1 = runSymbolsCb1(1, 2);
        runSymbolsCr1 = runLength(qBlockCr1, DCpredCr1);
        DCpredCr1 = runSymbolsCr1(1, 2);
        % Entropy Measurement - Run Length
        SymbolsCb1 = cat(1, SymbolsCb1, runSymbolsCb1);
        SymbolsCr1 = cat(1, SymbolsCr1, runSymbolsCr1);
    end
end
DCpredCb2 = 0;
dctBlocksCb2 = zeros(0,8);
SymbolsCb2 = zeros(0,2);
DCpredCr2 = 0;
dctBlocksCr2 = zeros(0,8);
SymbolsCr2 = zeros(0,2);
for i = 0:8:(size(Cb2, 1)-8)+1
    for j = 0:8:(size(Cb2, 2)-8)+1
        % Create blocks
        blockCb2 = Cb2(i+1:i+8, j+1:j+8);
        blockCr2 = Cr2(i+1:i+8, j+1:j+8);
        % DCT transform 
        dctBlockCb2 = blockDCT(blockCb2);  
        dctBlockCr2 = blockDCT(blockCr2);
        % Quantization
        qBlockCb2 = quantizeJPEG(dctBlockCb2, qTable, qScale2);
        qBlockCr2 = quantizeJPEG(dctBlockCr2, qTable, qScale2);
        % Entropy Measurement - qDCT
        dctBlocksCb2 = cat(1, dctBlocksCb2, qBlockCb2);
        dctBlocksCr2 = cat(1, dctBlocksCr2, qBlockCr2);
        % ZigZag
        runSymbolsCb2 = runLength(qBlockCb2, DCpredCb2);
        DCpredCb2 = runSymbolsCb2(1, 2);
        runSymbolsCr2 = runLength(qBlockCr2, DCpredCr2);
        DCpredCr2 = runSymbolsCr2(1, 2);
        % Entropy Measurement - Run Length
        SymbolsCb2 = cat(1, SymbolsCb2, runSymbolsCb2);
        SymbolsCr2 = cat(1, SymbolsCr2, runSymbolsCr2);
    end
end

%% Entropy Measurement - qDCT
% Image 1 - Y
freq = histc(dctBlocksY1(:), unique(dctBlocksY1(:)));
p = freq / sum(freq);
entrdctY1 = - sum(p .* log(p)/log(2));
% Image 1 - Cb
freq = histc(dctBlocksCb1(:), unique(dctBlocksCb1(:)));
p = freq / sum(freq);
entrdctCb1 = - sum(p .* log(p)/log(2));
% Image 1 - Cr
freq = histc(dctBlocksCr1(:), unique(dctBlocksCr1(:)));
p = freq / sum(freq);
entrdctCr1 = - sum(p .* log(p)/log(2));
% Save Entropies
qDCTentropy1 = [entrdctY1, entrdctCb1, entrdctCr1];

% Image 2 - Y
freq = histc(dctBlocksY2(:), unique(dctBlocksY2(:)));
p = freq / sum(freq);
entrdctY2 = - sum(p .* log(p)/log(2));
% Image 2 - Cb
freq = histc(dctBlocksCb2(:), unique(dctBlocksCb2(:)));
p = freq / sum(freq);
entrdctCb2 = - sum(p .* log(p)/log(2));
% Image 2 - Cr
freq = histc(dctBlocksCr2(:), unique(dctBlocksCr2(:)));
p = freq / sum(freq);
entrdctCr2 = - sum(p .* log(p)/log(2));
% Save Entropies
qDCTentropy2 = [entrdctY2, entrdctCb2, entrdctCr2];

%% Entropy Measurement - Run Length
% Image 1 - Y
[Au,~,ic] = unique(SymbolsY1,'rows');
freq = accumarray(ic,1);
p = freq / sum(freq);
entrRunSY1 = - sum(p .* log(p)/log(2));
% Image 1 - Cb
[Au,~,ic] = unique(SymbolsCb1,'rows');
freq = accumarray(ic,1);
p = freq / sum(freq);
entrRunSCb1 = - sum(p .* log(p)/log(2));
% Image 1 - Cr
[Au,~,ic] = unique(SymbolsCr1,'rows');
freq = accumarray(ic,1);
p = freq / sum(freq);
entrRunSCr1 = - sum(p .* log(p)/log(2));
% Save Entropies
RunSentropy1 = [entrRunSY1, entrRunSCb1, entrRunSCr1];

% Image 2 - Y
[Au,~,ic] = unique(SymbolsY2,'rows');
freq = accumarray(ic,1);
p = freq / sum(freq);
entrRunSY2 = - sum(p .* log(p)/log(2));
% Image 2 - Cb
[Au,~,ic] = unique(SymbolsCb2,'rows');
freq = accumarray(ic,1);
p = freq / sum(freq);
entrRunSCb2 = - sum(p .* log(p)/log(2));
% Image 2 - Cr
[Au,~,ic] = unique(SymbolsCr2,'rows');
freq = accumarray(ic,1);
p = freq / sum(freq);
entrRunSCr2 = - sum(p .* log(p)/log(2));
% Save Entropies
RunSentropy2 = [entrRunSY2, entrRunSCb2, entrRunSCr2];

%% Results
entropyResults1 = [SDentropy1; qDCTentropy1; RunSentropy1];
entropyResults2 = [SDentropy2; qDCTentropy2; RunSentropy2];

entropyResults1
entropyResults2

%%
%entropyResults1 =
%
%    7.6960    7.4730    7.7470
%    1.7645    0.5045    0.4578
%    6.0829    5.7053    5.6282
%
%
%entropyResults2 =
%
%    7.6207    7.6725    7.5972
%    0.2345    0.1078    0.0767
%    5.0359    4.1767    3.4650
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

