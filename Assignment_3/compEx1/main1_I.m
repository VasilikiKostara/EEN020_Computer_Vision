clc;
clear;

% Load
im2 = imread("kronan2.jpg");
whos("-file", "compEx1data.mat");
data = load("compEx1data.mat", "x");

x1 = data.x{1};
x2 = data.x{2};
n_points = size(x1, 2);


% With Normalization
% Kronan 1
mean1x = mean(x1(1, :));
mean1y = mean(x1(2, :));
std1x = std(x1(1, :));
std1y = std(x1(2, :));
N1 = [1/std1x 0 -mean1x/std1x; 0 1/std1y -mean1y/std1y; 0 0 1];
norm1 = pflat(N1 * x1);

% Kronan 2
mean2x = mean(x2(1, :));
mean2y = mean(x2(2, :));
std2x = std(x2(1, :));
std2y = std(x2(2, :));
N2 = [1/std2x 0 -mean2x/std2x; 0 1/std2y -mean2y/std2y; 0 0 1];
norm2 = pflat(N2 * x2);


% Fundamental matrix
[Fn_approx, minEigenvalue, norm_Mv] = estimate_F_DLT(norm1, norm2);
[Fn, detFn] = enforce_fundamental(Fn_approx);

epipolar_constraints = norm2' * Fn * norm1;

F = N2' * Fn * N1;
F = F./ F(3, 3);

[lines, distances, error] = compute_epipolar_errors(F, x1, x2);

% 20 Random Points
n_indices = 20;
random_indices = randperm(n_points, n_indices);
random_points = x2(:, random_indices);
random_lines = lines(:, random_indices);



% PLOTS
% 
figure;
plot(diag(epipolar_constraints));
xlim([ 0, n_points]);
ylim([-0.1, 0.1]);
title("Epipolar Constraints")

%
figure;
imshow(im2);
hold on;
scatter(random_points(1, :), random_points(2, :), 'o', 'filled','r')
rital(random_lines, 'b-');
title('Random Points and Epipolar Lines')
axis equal;
hold off;

%
figure;
bins = 100;
histogram(distances, bins);
















