clc;
clear;

im1 = imread("fountain1.png");
im2 = imread("fountain2.png");

[f1 d1] = vl_sift(single(rgb2gray(im1)));
[f2 d2] = vl_sift(single(rgb2gray(im2)));

[matches, scores] = vl_ubcmatch(d1, d2);

x1 = [f1(1, matches(1, :)); f1(2, matches(1, :))];
x2 = [f2(1, matches(2, :)); f2(2, matches(2, :))];

save('sift_points.mat','x1','x2');



