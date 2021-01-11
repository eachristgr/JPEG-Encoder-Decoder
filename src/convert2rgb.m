%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.1.2 Funtion convert2rgb
function imageRGB = convert2rgb(imageY, imageCr, imageCb, subimg)
%% Upsample - Average of neighbors
if ((size(imageCb, 1) == size(imageY, 1)) & (size(imageCb, 2) == size(imageY, 2)))
    subimg = [4 4 4];
end
if ((size(imageCb, 1) == size(imageY, 1)) & (size(imageCb, 2) == size(imageY, 2)/2))
    subimg = [4 2 2];
end
if ((size(imageCb, 1) == size(imageY, 1)/2) & (size(imageCb, 2) == size(imageY, 2)/2))
    subimg = [4 2 0];
end

if isequal([4 4 4], subimg)
    % 4:4:4 - Do Nothing
elseif isequal([4 2 2], subimg)
    % 4:2:2 - Cb, Cr ex. 500 x 250 -> 500 x 500
    imageCb = transpose(upsample(transpose(imageCb), 2));
    imageCb(:, 2:2:end) = (imageCb(:, 1:2:end) + cat(2, imageCb(:, 3:2:end), imageCb(:, end)))/2;
    imageCr = transpose(upsample(transpose(imageCr), 2));
    imageCr(:, 2:2:end) = (imageCr(:, 1:2:end) + cat(2, imageCr(:, 3:2:end), imageCr(:, end)))/2;
elseif isequal([4 2 0], subimg)
    % 4:2:0 - Cb, Cr ex. 250 x 250 -> 500 x 500
    imageCb = transpose(upsample(transpose(imageCb), 2));
    imageCb = upsample(imageCb, 2);
    imageCb(:, 2:2:end) = (imageCb(:, 1:2:end) + cat(2, imageCb(:, 3:2:end), imageCb(:, end)))/2;
    imageCb(2:2:end, :) = (imageCb(1:2:end, :) + cat(1, imageCb(3:2:end, :), imageCb(end, :)))/2;
    imageCr = transpose(upsample(transpose(imageCr), 2));
    imageCr = upsample(imageCr, 2);
    imageCr(:, 2:2:end) = (imageCr(:, 1:2:end) + cat(2, imageCr(:, 3:2:end), imageCr(:, end)))/2;
    imageCr(2:2:end, :) = (imageCr(1:2:end, :) + cat(1, imageCr(3:2:end, :), imageCr(end, :)))/2;
end

%% Center Cb, Cr (0, 255) -> (-127.5, 127.5)
imageY = imageY;
imageCb = imageCb - 127.5;
imageCr = imageCr - 127.5;

%% Convert to R, G, B
% (0, 255)double -> (0, 255)uint8
imageR = uint8(1*imageY + 0*imageCb + 1.402*imageCr);
imageG = uint8(1*imageY - 0.344136*imageCb - 0.714136*imageCr);
imageB = uint8(1*imageY + 1.772*imageCb + 0*imageCr);

%% Merge to RGB
imageRGB = cat(3, imageR, imageG, imageB);

end
