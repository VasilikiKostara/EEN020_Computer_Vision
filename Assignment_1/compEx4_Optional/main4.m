clc;
% Load
whos("-file", "compEx4.mat");
data = load("compEx4.mat", "K", "corners", "v");

K = data.K;
corners = data.corners; % already flattened
v = data.v;

imPath = 'compEx4.jpg';
im = imread(imPath);

% P1 = [I 0]
plane = pflat(v);
plane = plane(1:3);
norm_corners = K\ corners;
s = - plane' * norm_corners;
U = [norm_corners ; s];
flatU = pflat(U);
P1 = [eye(3), zeros(3, 1)];
[center1, axis1] = camera_center_and_axis(P1); 

% P2 = [R t]
R = [cos(pi/6) 0 -sin(pi/6) ; 0 1 0 ; sin(pi/6) 0 cos(pi/6)];
center2 = [-2; 0; 0]; 
t = - R * center2;
P2 = [R t];
[center2, axis2] = camera_center_and_axis(P2);

% Homography
H = R - t * plane';
trans_corners = pflat(H * norm_corners);
trans_U = pflat(P2 * U);

% Final Homography
H_tot = K * H / K;
final_corners = pflat(H_tot * corners);
tform = projective2d(H_tot.');
[final_im, RB] = imwarp(im, tform);


% Plots

% 1. Poster with corners and origin
% zoom out to see center1
figure(1);
imshow(im);
hold on;
plot_points_2D(corners);
scatter(center1(1), center1(2), 'o', 'filled', 'red'); 
hold off;

% 2. Normalized corners and origin
figure(2);
plot_points_2D(norm_corners);
hold on;
scatter(center1(1), center1(2), 'o', 'filled', 'red');
axis ij;
hold off;

% 3. 3D corners, camera center and principal axis
figure(3);
plot_points_3D(flatU);
hold on;
scale = 5;
plot_camera(P1, scale); % perpendicular to xy
plot_camera(P2, scale);
hold off;

% 4. Transformed corners and U points overlap in 2D
figure(4);
scatter(trans_corners(1, :), trans_corners(2, :), '.', 'blue');
hold on;
scatter(trans_U(1, :), trans_U(2, :), 'o','red');
grid on;
axis on;
axis ij;
axis equal;
hold off;

% 5. Final image and corners
% zoom out
figure(5);
imshow(final_im, RB);
hold on;
plot(final_corners(1, [1:end 1]), final_corners(2, [1:end 1]), 'o-');
grid on;
axis equal;
axis on;
axis ij;
hold off;

