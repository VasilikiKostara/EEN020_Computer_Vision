clc;
clear;

% Load
im2 = imread("kronan2.jpg");
data = load("compEx1data.mat", "x");
calibration = load("compEx2data.mat", "K");
essential = load("essential.mat", "E");

x1 = data.x{1};
x2 = data.x{2};
K = calibration.K;
E = essential.E;

n_points = size(x1, 2);
n_cameras2 = 4;
scale = 3;

norm1 = pflat(K^(-1) * x1);        % Kronan 1
norm2 = pflat(K^(-1) * x2);        % Kronan 2

P1 = [eye(3) zeros(3, 1)];
[center1, ~] = camera_center_and_axis(P1);
P2 = extract_P_from_E(E);
X = cell(1, 4);

for i = 1:n_cameras2
    X{i} = pflat(triangulate_3D_point_DLT(P1, P2{i}, norm1, norm2));
    [center2, ~] = camera_center_and_axis(P2{i});

    % Plots
    figure(i);
    plot3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'.b','Markersize',3);
    hold on;
    plot_camera(P1, scale);
    plot_camera(P2{i}, scale);
    title(sprintf('3D Points %d', i));
    axis equal;
    hold off;
end

% Choose P2 = P2{3} = [U * W' * V' | u]
P2 = K*(-1) * P2{3};
X = X{3};
proj2 = pflat(P2 * X);

% Final Plot
figure;
imshow(im2);
hold on;
plot(x2(1, :), x2(2, :), 'bo')
plot(proj2(1, :), proj2(2, :), 'r*')
legend('Matched Image Points', 'Projected 3D Points')
axis equal;
hold off;




