clc;
clear;

% Load
im2 = imread("kronan2.jpg");
data = load("compEx1data.mat", "x");
calibration = load("compEx2data.mat", "K");

x1 = data.x{1};
x2 = data.x{2};
n_points = size(x1, 2);
K = calibration.K;

norm1 = pflat(K^(-1) * x1);        % Kronan 1
norm2 = pflat(K^(-1) * x2);        % Kronan 2

% Essential matrix
[E_approx, minEigenvalue, norm_Mv] = estimate_F_DLT(norm1, norm2);
[E, detE] = enforce_essential(E_approx);
E = E./ E(end);

% Epipolar Constraints
epipolar_constraints = norm2' * E * norm1;
mean_epipolar = mean(epipolar_constraints, "all");

% Fundamental Matrix
F = convert_E_to_F(E,K,K);
F = F./F(end);

% Epipolar Lines
[lines, distances, error] = compute_epipolar_errors(F, x1, x2);

% 20 Random Points
n_indices = 20;
random_indices = randperm(n_points, n_indices);
random_points = x2(:, random_indices);
random_lines = lines(:, random_indices);

% Save Essential
save('essential.mat','E')

% PLOTS
%
figure(1);
plot(diag(epipolar_constraints));
xlim([ 0, n_points]);
title("Epipolar Constraints")

%
figure(2);
imshow(im2);
hold on;
scatter(random_points(1, :), random_points(2, :), 'o', 'filled','r')
rital(random_lines, 'b-');
title('Random Points and Epipolar Lines')
axis equal;
hold off;

%
figure(3);
bins = 100;
histogram(distances, bins);

