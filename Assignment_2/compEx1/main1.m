clc;

% Load
whos("-file", "compEx1data.mat");
data = load("compEx1data.mat", "P", "X", "imfiles", "x");

P = data.P;
X = data.X;
imfiles = data.imfiles;
x = data.x;

P1 = P{1};
proj1 = pflat(P1 * X);
x1 = x{1};
im1 = imread(imfiles{1});

T1 = [1 0 0 0; 0 3 0 0; 0 0 1 0; 1/8 1/8 0 1];
T2 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 1/16 1/16 0 1];
trans1 = pflat(T1 * X);
trans2 = pflat(T2 * X);

trans_camera1 = P1 * (T1)^(-1);
trans_camera2 = P1 * (T2)^(-1);
proj_trans1 = pflat(trans_camera1 * trans1);
proj_trans2 = pflat(trans_camera2 * trans2);

% PLOTS
%
figure(1);
plot_points_3D(X);
hold on;
for j = 1:length(P)
    plotcams(P(j))
end
hold off;

%
figure(2);
visible = isfinite (x1(1 ,:));
imshow(im1)
hold on;
plot(proj1(1, visible), proj1(2, visible), ' ro ');
plot(x1(1, visible), x1(2, visible ), ' * ', 'MarkerEdgeColor', '#77AC30');
legend('X projection', 'x1')
hold off;

%
figure(3);
scatter3(trans1(1, :), trans1(2, :), trans1(3, :), '.');
hold on;
scatter3(trans2(1, :), trans2(2, :), trans2(3, :), '.');
for j = 1:length(P)
    plotcams({P{j} * (T1)^(-1)})
    plotcams({P{j} * (T2)^(-1)})
end
xlabel('x');
ylabel('y');
zlabel('z');
grid on;
axis equal;
legend('transformed 1', 'transformed 2')
hold off;

%
figure(4);
imshow(im1);
hold on;
scatter(x1(1, :), x1(2, :), 'o', 'b');
scatter(proj_trans1(1, :), proj_trans1(2, :), '*', 'r');
scatter(proj_trans2(1, :), proj_trans2(2, :), '.','MarkerEdgeColor', 'g');
xlabel('x');
ylabel('y');
grid on;
axis equal;
legend('x1', 'transformed 1', 'transformed 2');
hold off;


