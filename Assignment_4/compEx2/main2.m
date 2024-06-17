clc;
clear;
close all;

% Load
im1 = imread("fountain1.png");
im2 = imread("fountain2.png");
data = load("compEx2data.mat", "K");
sift = load("sift_points.mat", "x1", "x2");

K = data.K;
n_points = size(sift.x1, 2);
x1 = [sift.x1; ones(1, n_points)];
x2 = [sift.x2; ones(1, n_points)];

[E, inliers1, inliers2, eRMS] = estimate_E_robust(K, x1, x2);
n_inliers = size(inliers1, 2);

% Camera Matrices
n_cameras2 = 4;
scale = 0.5;

norm1 = pflat(K^(-1) * inliers1);        % Fountain 1
norm2 = pflat(K^(-1) * inliers2);        % Fountain 2

P1 = [eye(3) zeros(3, 1)];
[center1, ~] = camera_center_and_axis(P1);
P2 = extract_P_from_E(E);
X = cell(1, 4);
n_front = zeros(1, 4);

for i = 1:n_cameras2
    X{i} = pflat(triangulate_3D_point_DLT(P1, P2{i}, norm1, norm2));
    [center2, ~] = camera_center_and_axis(P2{i});
    n_front(i) = sum(P2{i}(3, :) * X{i} > 0);

    % Plots
    subplot(2, 2, i);
    plot3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'.b','Markersize',3);
    hold on;
    plot_camera(P1, scale);
    plot_camera(P2{i}, scale);
    title(sprintf('3D Points %d', i));
    axis equal;
    hold off;
end

% Choosing P_1,2 with the most X points in front
[~, index] = max(n_front);
P2 = P2{index};
X = X{index};

