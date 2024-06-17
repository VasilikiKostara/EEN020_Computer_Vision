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

% Inliers
[E, inliers1, inliers2, eRMS] = estimate_E_robust(K, x1, x2);
n_inliers = size(inliers1, 2);
norm1 = pflat(K^(-1) * inliers1);        % Fountain 1
norm2 = pflat(K^(-1) * inliers2);        % Fountain 2

% Camera Matrices & 3D Points
P1 = [eye(3) zeros(3, 1)];
P2 = extract_P_from_E(E);
X = cell(1, 4);
n_front = zeros(1, 4);
n_cameras2 = 4;

for i = 1:n_cameras2
    X{i} = pflat(triangulate_3D_point_DLT(P1, P2{i}, norm1, norm2));
    n_front(i) = sum(P2{i}(3, :) * X{i} > 0);
end

% Choosing P_1,2 with the most X points in front
[~, index] = max(n_front);
P2 = P2{index};
X = X{index};

load("compEx3data.mat");
P1 = P{1};
P2 = P{2};
X_opt = zeros(size(X));
max_iteration = 10^9;

error_X = zeros(1, n_inliers);
error_X_dX = zeros(1, n_inliers);

for j = 1:n_inliers
    Xj = pflat(X(:, j));
    x1j = x1(:, j);
    x2j = x2(:, j);
    mu = 1;
    iteration = 0;
    [error_X(j), ~] = ComputeReprojectionError(P1, P2, Xj, x1j, x2j);

    while (mu<10^6 && mu>10^(-6) && iteration<max_iteration)
        [err1, ~] = ComputeReprojectionError(P1, P2, Xj, x1j, x2j);
        [r, J] = LinearizeReprojErr(P1, P2, Xj, x1j, x2j);
        
        delta_X = ComputeUpdate(r, J, mu);
        Xj_dX = pflat(Xj + delta_X);
        [err2, ~] = ComputeReprojectionError(P1, P2, Xj_dX, x1j, x2j);

        if err1 <= err2
            mu = 10 * mu;
            Xj = pflat(Xj);
        else 
            mu = 0.1 * mu;
            delta_X = ComputeUpdate(r, J, mu);
            Xj = Xj_dX;
        end

        iteration = iteration +1;
    end
    X_opt(:, j) = Xj;
    [error_X_dX(j), ~] = ComputeReprojectionError(P1, P2, Xj_dX, x1j, x2j);
end

sum_before = sum(error_X);
sum_after = sum(error_X_dX);
median_before = sum_before / n_inliers;
median_after = sum_after / n_inliers;


figure;
plot3(X(1, :), X(2, :), X(3, :), ".b");
hold on;
plot3(X_opt(1, :), X_opt(2, :), X_opt(3, :), ".r");
axis equal;
hold off;












