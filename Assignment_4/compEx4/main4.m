clc;
clear;
close all;

% Load
im1 = imread("fountain1.png");
im2 = imread("fountain2.png");
data = load("compEx3data.mat", "K", "P", "X", "x");

K = data.K;
P = data.P;
X = pflat(data.X);
x = data.x;

P1 = P{1};
P2 = P{2};
x1 = x{1};
x2 = x{2};
n_inliers = size(X, 2);

% Optimization
X_opt = zeros(size(X));
max_iteration = 10^6;

std = 0.1;
X = X + std * randn(size(X));
std = 3;
x1 = x1 + std * randn(size(x1));
x2 = x2 + std * randn(size(x2));

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
        [r, J] = LinearizeReprojErr(P1, P2, Xj, x1j, x2j);    
        delta_X = ComputeUpdate(r, J, mu);
        Xj_dX = pflat(Xj + delta_X);

        [err1, ~] = ComputeReprojectionError(P1, P2, Xj, x1j, x2j);
        [err2, ~] = ComputeReprojectionError(P1, P2, Xj_dX, x1j, x2j);

        if err1 <= err2
            mu = 10 * mu;
            Xj = pflat(Xj);
        else 
            mu = 0.1 * mu;
            Xj = Xj_dX;
        end

        iteration = iteration +1;
    end
    X_opt(:, j) = Xj;
    [error_X_dX(j), ~] = ComputeReprojectionError(P1, P2, Xj_dX, x1j, x2j);
end

sum_before = sum(error_X);
sum_after = sum(error_X_dX);
median_before = median(error_X);
median_after = median(error_X_dX);


figure;
scale = 0.5;
plot3(X(1, :), X(2, :), X(3, :), ".b", 'MarkerSize', 1);
hold on;
plot3(X_opt(1, :), X_opt(2, :), X_opt(3, :), ".r");
plot_camera(P1, scale);
plot_camera(P2, scale);
axis equal;
hold off;

