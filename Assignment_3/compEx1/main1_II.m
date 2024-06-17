clc;
clear;

% Load
im2 = imread("kronan2.jpg");
whos("-file", "compEx1data.mat");
data = load("compEx1data.mat", "x");

x1 = data.x{1};
x2 = data.x{2};
n_points = size(x1, 2);


% Without Normalization
% Fundamental Matrix
[F_approx, minEigenvalue, norm_Mv] = estimate_F_DLT(x1, x2);
[F, detF] = enforce_fundamental(F_approx);
F = F./ F(3, 3);

% Epipolar Constraints
epipolar_constraints = x2' * F * x1;
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
















