clc;
im1 = imread('cube1.jpg');
im2 = imread('cube2.jpg');

[f1 d1] = vl_sift(single(rgb2gray(im1)), 'PeakThresh', 1);
[f2 d2] = vl_sift(single(rgb2gray(im2)), 'PeakThresh', 1);

[matches, scores] = vl_ubcmatch(d1, d2);

x1 = [f1(1, matches(1, :)); f1(2, matches(1, :))];
x2 = [f2(1, matches(2, :)); f2(2, matches(2, :))];

save('matching_points.mat','x1','x2');

figure(1);
imshow(im1);
hold on;
vl_plotframe(f1);
hold off;

figure(2);
imshow(im2);
hold on;
vl_plotframe(f2);
hold off;

perm = randperm(size(matches, 2));
figure(3);
imagesc([im1 im2]);
hold on;
plot([x1(1, perm(1:10)); x2(1, perm(1:10)) + size(im1 ,2)] , [x1(2, perm (1:10)); x2(2, perm (1:10))] , ' - ');
hold off;




