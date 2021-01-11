%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
% 1.6 Demo 1

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

%% 1st Question (RGB -> YCbCr -> RGB)
% Load Images
load('img1_down.mat');
imageRGB1 = img1_down;
load('img2_down.mat');
imageRGB2 = img2_down;

% Convert to YCbCr
subimg1 = [4 2 2];	% image 1 : RGB -> YCbCr 4:2:2
[Y1, Cb1, Cr1] = convert2ycbcr(imageRGB1, subimg1);
subimg2 = [4 4 4];	% image 2 : RGB -> YCbCr 4:4:4
[Y2, Cb2, Cr2] = convert2ycbcr(imageRGB2, subimg2);

% Convert to RGB
Q1imageRGB1 = convert2rgb(Y1, Cr1, Cb1, subimg1);
Q1imageRGB2 = convert2rgb(Y2, Cr2, Cb2, subimg2);

% Show Original VS Reconstructed Images
figure;
subplot(2,2,1);
imshow(imageRGB1);
title('Image 1 - Original');
subplot(2,2,2);
imshow(Q1imageRGB1);
title('Image 1 - Reconstructed (Downsample 4:2:2)');
subplot(2,2,3);
imshow(imageRGB2);
title('Image 2 - Original');
subplot(2,2,4);
imshow(Q1imageRGB2);
title('Image 2 - Reconstructed (Downsample 4:4:4)');

%% 2nd Question (RGB -> YCbCr -> DCT -> Quantization -> ... -> RGB)
qScale1 = 0.6;  % image 1 : qScale = 0.6
qScale2 = 5;    % image 2 : qScale = 5

% Luminance (Y) component
qTable = qTableL;
for i = 0:8:(size(Y1, 1)-8)+1
    for j = 0:8:(size(Y1, 2)-8)+1
        % Create blocks
        blockY1 = Y1(i+1:i+8, j+1:j+8);
        % DCT transform 
        dctBlockY1 = blockDCT(blockY1);  
        % Quantization
        qBlockY1 = quantizeJPEG(dctBlockY1, qTable, qScale1);
        % Dequantization
        dctBlockY1 = dequantizeJPEG(qBlockY1, qTable, qScale1);
        % InverseDCT transform
        blockY1 = iBlockDCT(dctBlockY1);
        % Merge blocks
        nY1(i+1:i+8, j+1:j+8) = blockY1;
    end
end
for i = 0:8:(size(Y2, 1)-8)+1
    for j = 0:8:(size(Y2, 2)-8)+1
        % Create blocks
        blockY2 = Y2(i+1:i+8, j+1:j+8);
        % DCT transform 
        dctBlockY2 = blockDCT(blockY2);  
        % Quantization
        qBlockY2 = quantizeJPEG(dctBlockY2, qTable, qScale2);
        % Dequantization
        dctBlockY2 = dequantizeJPEG(qBlockY2, qTable, qScale2);
        % InverseDCT transform
        blockY2 = iBlockDCT(dctBlockY2);
        % Merge blocks
        nY2(i+1:i+8, j+1:j+8) = blockY2;
    end
end

% Chrominance (Cb, Cr) components
qTable = qTableC;
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
        % Dequantization
        dctBlockCb1 = dequantizeJPEG(qBlockCb1, qTable, qScale1);
        dctBlockCr1 = dequantizeJPEG(qBlockCr1, qTable, qScale1);
        % InverseDCT transform
        blockCb1 = iBlockDCT(dctBlockCb1);
        blockCr1 = iBlockDCT(dctBlockCr1);
        % Merge blocks
        nCb1(i+1:i+8, j+1:j+8) = blockCb1;
        nCr1(i+1:i+8, j+1:j+8) = blockCr1;
    end
end
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
        % Dequantization
        dctBlockCb2 = dequantizeJPEG(qBlockCb2, qTable, qScale2);
        dctBlockCr2 = dequantizeJPEG(qBlockCr2, qTable, qScale2);
        % InverseDCT transform
        blockCb2 = iBlockDCT(dctBlockCb2);
        blockCr2 = iBlockDCT(dctBlockCr2);
        % Merge blocks
        nCb2(i+1:i+8, j+1:j+8) = blockCb2;
        nCr2(i+1:i+8, j+1:j+8) = blockCr2;
    end
end

% Convert to RGB
Q2imageRGB1 = convert2rgb(nY1, nCr1, nCb1, subimg1);
Q2imageRGB2 = convert2rgb(nY2, nCr2, nCb2, subimg2);

% Show Original VS Reconstructed Images
figure;
subplot(2,2,1);
imshow(imageRGB1);
title('Image 1 - Original');
subplot(2,2,2);
imshow(Q2imageRGB1);
title('Image 1 - Reconstructed (Downsample 4:2:2 | qScale = 0.6)');
subplot(2,2,3);
imshow(imageRGB2);
title('Image 2 - Original');
subplot(2,2,4);
imshow(Q2imageRGB2);
title('Image 2 - Reconstructed (Downsample 4:4:4 | qScale = 5)');
