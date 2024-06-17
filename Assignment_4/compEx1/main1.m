clc;
clear;
close all;
whos("-file", "compEx1data.mat");

% Load
im1 = imread("round_church1.jpg");
im2 = imread("round_church2.jpg");
data = load("compEx1data.mat", "K", "x");
K = data.K;
x = data.x;

x1 = pflat(x{1});
x2 = pflat(x{2});
norm1 = pflat(K^(-1) * x1);
norm2 = pflat(K^(-1) * x2);
n_points = size(x1, 2);

[E_approx, minEigenvalue, norm_Mv] = estimate_F_DLT(norm1, norm2);
[E, detE] = enforce_essential(E_approx);
Fn = convert_E_to_F(E, K, K);
[F, detF] = enforce_fundamental(Fn);

[l1, d1, mean_distance1] = compute_epipolar_errors(F', x2, x1);
[l2, d2, mean_distance2] = compute_epipolar_errors(F, x1, x2);
eRMS = sqrt(0.5 * sum(d1.^2 + d2.^2) / n_points);

% 20 Random Points
n_indices = 20;
random_indices = randperm(n_points, n_indices);

% 1
random_points1 = x1(:, random_indices);
random_lines1 = l1(:, random_indices);

% 2
random_points2 = x2(:, random_indices);
random_lines2 = l2(:, random_indices);


% Robust
[Er, inliers1, inliers2, eRMSr] = estimate_E_robust(K, x1, x2);
Fnr = convert_E_to_F(Er, K, K);
[Fr, detFr] = enforce_fundamental(Fnr);

[l1r, d1r, mean_distance1r] = compute_epipolar_errors(Fr', inliers2, inliers1);
[l2r, d2r, mean_distance2r] = compute_epipolar_errors(Fr, inliers1, inliers2);


% 20 Random Inliers
n_inliers = size(inliers1, 2);
random_inliers = randperm(n_inliers, n_indices);

% 1
random_inliers1 = inliers1(:, random_inliers);
random_lines1r = l1r(:, random_inliers);

% 2
random_inliers2 = inliers2(:, random_inliers);
random_lines2r = l2r(:, random_inliers);


% % Plots
figure;
bins = 100;
subplot(1, 2, 1);
histogram(d1, bins);
subplot(1, 2, 2);
histogram(d2, bins);

figure;
imshow(im1);
hold on;
scatter(random_points1(1, :), random_points1(2, :), 'o', 'filled','r')
rital(random_lines1, 'b-');
title('Random Points and Epipolar Lines')
axis equal;
hold off;

figure;
imshow(im2);
hold on;
scatter(random_points2(1, :), random_points2(2, :), 'o', 'filled','r')
rital(random_lines2, 'b-');
title('Random Points and Epipolar Lines')
axis equal;
hold off;

% Robust
%
figure;
bins = 100;
subplot(1, 2, 1);
histogram(d1r, bins);
subplot(1, 2, 2);
histogram(d2r, bins);

figure;
imshow(im1);
hold on;
scatter(random_inliers1(1, :), random_inliers1(2, :), 'o', 'filled','r')
rital(random_lines1r, 'b-');
title('Random Points and Epipolar Lines')
axis equal;
hold off;

figure;
imshow(im2);
hold on;
scatter(random_inliers2(1, :), random_inliers2(2, :), 'o', 'filled','r')
rital(random_lines2r, 'b-');
title('Random Points and Epipolar Lines')
axis equal;
hold off;