%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.3.1 Funtion quantizeJPEG
function qBlock = quantizeJPEG(dctBlock, qTable, qScale)
% Compute qTable
qTable = qScale .* qTable;

%% Remove High Frequencies (1st Way)
%maxDCT = max(abs(dctBlock(:)));
% 20 coefficients
%qTable(8,4:8) = maxDCT;
%qTable(7,4:8) = maxDCT;
%qTable(6,5:8) = maxDCT;
%qTable(5,6:8) = maxDCT;
%qTable(4,7:8) = maxDCT;
%qTable(3,8:8) = maxDCT;

% 40 coefficients
%qTable(8,1:8) = maxDCT;
%qTable(7,1:8) = maxDCT;
%qTable(6,2:8) = maxDCT;
%qTable(5,3:8) = maxDCT;
%qTable(4,4:8) = maxDCT;
%qTable(3,6:8) = maxDCT;
%qTable(2,7:8) = maxDCT;
%qTable(1,8:8) = maxDCT;

% 50 coefficients
%qTable(8,1:8) = maxDCT;
%qTable(7,1:8) = maxDCT;
%qTable(6,1:8) = maxDCT;
%qTable(5,1:8) = maxDCT;
%qTable(4,3:8) = maxDCT;
%qTable(3,4:8) = maxDCT;
%qTable(2,5:8) = maxDCT;
%qTable(1,6:8) = maxDCT;

% 60 coefficients
%qTable(8,1:8) = maxDCT;
%qTable(7,1:8) = maxDCT;
%qTable(6,1:8) = maxDCT;
%qTable(5,1:8) = maxDCT;
%qTable(4,1:8) = maxDCT;
%qTable(3,1:8) = maxDCT;
%qTable(2,2:8) = maxDCT;
%qTable(1,4:8) = maxDCT;

% 63 coefficients
%qTable(8,1:8) = maxDCT;
%qTable(7,1:8) = maxDCT;
%qTable(6,1:8) = maxDCT;
%qTable(5,1:8) = maxDCT;
%qTable(4,1:8) = maxDCT;
%qTable(3,1:8) = maxDCT;
%qTable(2,1:8) = maxDCT;
%qTable(1,2:8) = maxDCT;

%% Quantization
qBlock = fix(dctBlock ./ qTable);

%% Remove High Frequencies (2nd Way)
% 20 coefficients
%qBlock(8,4:8) = 0;
%qBlock(7,4:8) = 0;
%qBlock(6,5:8) = 0;
%qBlock(5,6:8) = 0;
%qBlock(4,7:8) = 0;
%qBlock(3,8:8) = 0;

% 40 coefficients
%qBlock(8,1:8) = 0;
%qBlock(7,1:8) = 0;
%qBlock(6,2:8) = 0;
%qBlock(5,3:8) = 0;
%qBlock(4,4:8) = 0;
%qBlock(3,6:8) = 0;
%qBlock(2,7:8) = 0;
%qBlock(1,8:8) = 0;

% 50 coefficients
%qBlock(8,1:8) = 0;
%qBlock(7,1:8) = 0;
%qBlock(6,1:8) = 0;
%qBlock(5,1:8) = 0;
%qBlock(4,3:8) = 0;
%qBlock(3,4:8) = 0;
%qBlock(2,5:8) = 0;
%qBlock(1,6:8) = 0;

% 60 coefficients
%qBlock(8,1:8) = 0;
%qBlock(7,1:8) = 0;
%qBlock(6,1:8) = 0;
%qBlock(5,1:8) = 0;
%qBlock(4,1:8) = 0;
%qBlock(3,1:8) = 0;
%qBlock(2,2:8) = 0;
%qBlock(1,4:8) = 0;

% 63 coefficients
%qBlock(8,1:8) = 0;
%qBlock(7,1:8) = 0;
%qBlock(6,1:8) = 0;
%qBlock(5,1:8) = 0;
%qBlock(4,1:8) = 0;
%qBlock(3,1:8) = 0;
%qBlock(2,1:8) = 0;
%qBlock(1,2:8) = 0;

end
