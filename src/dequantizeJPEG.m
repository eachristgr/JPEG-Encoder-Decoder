%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.3.2 Funtion dequantizeJPEG
function dctBlock = dequantizeJPEG(qBlock, qTable, qScale)
%% Compute qTable
qTable = qScale * qTable;

%% Dequantization
dctBlock = qBlock .* qTable;

end
