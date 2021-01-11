%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.2.2 Funtion iBlockDCT
function block = iBlockDCT(dctBlock)
%% Transform block 8 x 8
block = idct2(dctBlock);

%% (-127.5, 127.5) -> (0, 255)
block = block + 127.5;

end
