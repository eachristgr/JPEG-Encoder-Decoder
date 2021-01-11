%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.1.1 Funtion convert2ycbcr
function [imageY, imageCb, imageCr] = convert2ycbcr(imageRGB, subimg)
%% Size Correction (For integer num. of 8 x 8 blocks)
mod_row = mod(size(imageRGB, 1), 8);
startr = fix(mod_row/2);
endr = mod_row - startr;
mod_col = mod(size(imageRGB, 2), 8);
startc = fix(mod_col/2);
endc = mod_col - startc;
imageRGB = imageRGB(startr+1:1:end-endr, startc+1:1:end-endc, 1:1:end);

%% Get R, G, B
imageRGB = im2double(imageRGB); %(0, 255)uint8 -> (0, 1)double

imageR = imageRGB(:,:,1);   %R channel
imageG = imageRGB(:,:,2);   %G channel
imageB = imageRGB(:,:,3);   %B channel

%% Convert to Y, Cb, Cr
% (0, 1)double -> (0, 255)double
imageY = (0.299*imageR + 0.587*imageG + 0.114*imageB)*255;
imageCb = (-0.168736*imageR - 0.331264*imageG + 0.500*imageB + 0.5)*255;
imageCr = (0.500*imageR - 0.418688*imageG - 0.081312*imageB + 0.5)*255;

%% Downsample
if isequal([4 4 4], subimg)
    % 4:4:4 - Do Nothing
elseif isequal([4 2 2], subimg)
    % 4:2:2 - Cb, Cr ex. 500 x 500 -> 500 x 250
    imageCb = imageCb(:, 1:2:end);
    imageCr = imageCr(:, 1:2:end);
elseif isequal([4 2 0], subimg)
    % 4:2:0 - Cb, Cr ex. 500 x 500 -> 250 x 250
    imageCb = imageCb(:, 1:2:end);
    imageCb = imageCb(1:2:end, :);
    imageCr = imageCr(:, 1:2:end);
    imageCr = imageCr(1:2:end, :);
end

end
