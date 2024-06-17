clc;
% Load point pairs
whos("-file", "compEx2.mat");
data = load("compEx2.mat", "p1", "p2", "p3");

% Points already flattened
p1 = data.p1;
p2 = data.p2;
p3 = data.p3;

% Load compEx.jpg
imPath = 'compEx2.jpg';
im = imread(imPath);

% Coefficients of point pairs
coef_p1 = coefficients(p1)
coef_p2 = coefficients(p2)
coef_p3 = coefficients(p3)

% Intersection of l2 and l3, AX = 0 in homogeneous coordinates
A = [transpose(coef_p2); transpose(coef_p3)];
X = pflat(null(A))

% Distance between X and l1
distance = point_line_distance_2D(X, coef_p1)

% Plots
imshow(im);
hold on;
plot_points(p1, "blue")
plot_points(p2, "red")
plot_points(p3, "green")
rital(coef_p1, "blue")
rital(coef_p2, "red")
rital(coef_p3, "green")
scatter(X(1),X(2), 'o', 'filled', 'cyan')
hold off;

