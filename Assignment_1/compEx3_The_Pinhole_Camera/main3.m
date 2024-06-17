clc;
% Load point pairs
whos("-file", "compEx3.mat");
data = load("compEx3.mat", "P1", "P2", "U");

P1 = data.P1;
P2 = data.P2;
U = data.U;

% Load compEx.jpg
imPath1 = 'compEx3im1.jpg';
imPath2 = 'compEx3im2.jpg';
im1 = imread(imPath1);
im2 = imread(imPath2);

% Flatten & project
[center1, axis1] = camera_center_and_axis(P1)
[center2, axis2] = camera_center_and_axis(P2)
flatU = pflat(U);
proj1 = pflat(P1 * U);
proj2 = pflat(P2 * U);

% Plot
% 3D point model, centers and axes
figure;
s = 30;
plot_points_3D(flatU);
hold on;
plot_camera(P1, s);
plot_camera(P2, s);
hold off;

% 2D point model on image 1
figure;
imshow(im1);
hold on;
plot_points_2D(proj1);
hold off;

% 2D point model on image 2
figure;
imshow(im2);
hold on;
plot_points_2D(proj2);
hold off;



