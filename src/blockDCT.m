%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.2.1 Funtion dctBlock
function dctBlock = blockDCT(block)
%% (0, 255) -> (-127.5, 127.5)
block = block - 127.5;

%% iTransform block 8 x 8
dctBlock = dct2(block);

end
