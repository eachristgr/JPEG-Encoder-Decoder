%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 2 - JPEG Intergration
% 2.2 qScale influence

clear all;
clc;

%% qScale
qScale = [0.1, 0.3, 0.6, 1, 2, 5, 10];

%% Load Image
load('img1_down.mat');
imageRGB1 = img1_down;
load('img2_down.mat');
imageRGB2 = img2_down;

%% Size Correction
mod_row = mod(size(imageRGB1, 1), 8);
startr = fix(mod_row/2);
endr = mod_row - startr;
mod_col = mod(size(imageRGB1, 2), 8);
startc = fix(mod_col/2);
endc = mod_col - startc;
imageRGB1 = imageRGB1(startr+1:1:end-endr, startc+1:1:end-endc, 1:1:end);
mod_row = mod(size(imageRGB2, 1), 8);
startr = fix(mod_row/2);
endr = mod_row - startr;
mod_col = mod(size(imageRGB2, 2), 8);
startc = fix(mod_col/2);
endc = mod_col - startc;
imageRGB2 = imageRGB2(startr+1:1:end-endr, startc+1:1:end-endc, 1:1:end);

%% Find Results
bitsL1 = zeros(1, length(qScale));
MSE1 = zeros(1, length(qScale));
bitsL2 = zeros(1, length(qScale));
MSE2 = zeros(1, length(qScale));
for i = 1:length(qScale)
    % Encode
    JPEGenc1 = JPEGencode(imageRGB1, [4 2 2], qScale(i));
    JPEGenc2 = JPEGencode(imageRGB2, [4 4 4], qScale(i));
    % Count Total bits
    for j = 2:length(JPEGenc1)
        huffStream1 = convertStringsToChars(JPEGenc1{j}.huffStream);
        bitsL1(i) = bitsL1(i) + length(huffStream1);
    end
    for j = 2:length(JPEGenc2)
        huffStream2 = convertStringsToChars(JPEGenc2{j}.huffStream);
        bitsL2(i) = bitsL2(i) + length(huffStream2);
    end
    % Decode
    imgRec1 = JPEGdecode(JPEGenc1);
    imgRec2 = JPEGdecode(JPEGenc2);
    % Show Image
    %figure;
    %imshow(imgRec1);
    %figure;
    %imshow(imgRec2);
    % MSE
    MSE1(i) = immse(imgRec1, imageRGB1);
    MSE2(i) = immse(imgRec2, imageRGB2);
end


%% Plot Results
figure;
subplot(3,1,1);
plot(qScale, MSE1, 'b:d');
xlabel('qScale');
ylabel('MSE');
subplot(3,1,2);
plot(qScale, bitsL1, 'k:d');
xlabel('qScale');
ylabel('Total Bits');
subplot(3,1,3);
plot(bitsL1, MSE1, 'r:d');
xlabel('Total Bits');
ylabel('MSE');
suptitle('Image 1');

figure;
subplot(3,1,1);
plot(qScale, MSE2, 'b:d');
xlabel('qScale');
ylabel('MSE');
subplot(3,1,2);
plot(qScale, bitsL2, 'k:d');
xlabel('qScale');
ylabel('Total Bits');
subplot(3,1,3);
plot(bitsL2, MSE2, 'r:d');
xlabel('Total Bits');
ylabel('MSE');
suptitle('Image 2');
