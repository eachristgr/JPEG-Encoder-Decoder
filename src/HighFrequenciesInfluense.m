%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 2 - JPEG Intergration
% 2.2 High Frequencies Influense

clear all;
clc;

%% Load Image
load('img1_down.mat');
imageRGB1 = img1_down;
load('img2_down.mat');
imageRGB2 = img2_down;

%% Encode
JPEGenc1 = JPEGencode(imageRGB1, [4 2 0], 1);
JPEGenc2 = JPEGencode(imageRGB2, [4 2 0], 1);

%% Decode
imgRec1 = JPEGdecode(JPEGenc1);
imgRec2 = JPEGdecode(JPEGenc2);

%% Show Images
figure;
imshow(imgRec1);
figure;
imshow(imgRec2);

