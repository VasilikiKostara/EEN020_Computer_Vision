clc; 

points = load("matching_points.mat", "x1", "x2");
cameras = load("cube_cameras.mat", "P1_", "P2_");
im1 = imread('cube1.jpg');
im2 = imread('cube2.jpg');

x1 = points.x1;
x2 = points.x2;
P1 = cameras.P1_;
P2 = cameras.P2_;

% Matching Points 
X = triangulate_3D_point_DLT(P1, P2, x1, x2);
Xproj1 = pflat(P1 * X);
Xproj2 = pflat(P2 * X);

error1 = sqrt(sum(x1(1:2, :) - Xproj1(1:2, :)).^2);
error2 = sqrt(sum(x2(1:2, :) - Xproj2(1:2, :)).^2);
good_points = (error1 < 3 & error2 < 3 );
goodx1 = x1(:, good_points);
goodx2 = x2(:, good_points);
goodX = pflat(X(:, good_points));

goodXproj1 = pflat(P1 * goodX);
goodXproj2 = pflat(P2 * goodX);


% Normalized with K^-1
[K1, Rt1] = rq(P1);
[K2, Rt2] = rq(P2);
K1 = K1 / K1(3,3);
K2 = K2 / K2(3,3);

x1_ = K1^(-1) * [x1; ones(1, size(x1, 2))];
x2_ = K2^(-1) * [x2; ones(1, size(x2, 2))];
X_ = (triangulate_3D_point_DLT(Rt1, Rt2, x1_, x2_));
Xproj1_ = pflat(P1 * X_);
Xproj2_ = pflat(P2 * X_);

error1_ = sqrt(sum(x1(1:2, :) - Xproj1_(1:2, :)).^2);
error2_ = sqrt(sum(x2(1:2, :) - Xproj2_(1:2, :)).^2);
good_points_ = (error1 < 3 & error2 < 3 );
goodX_ = pflat(X(:, good_points_));
goodXproj1_ = pflat(P1 * goodX_);
goodXproj2_ = pflat(P2 * goodX_);



% PLOTS 
% Matching Points 
figure(1);
subplot(1, 2, 1);
imshow(im1);
hold on;
scatter(Xproj1(1, :), Xproj1(2, :), 'o', 'r');
scatter(x1(1, :), x1(2, :), '.', 'g');
axis equal;
legend('X projection 1', 'SIFT points 1');
hold off;

subplot(1, 2, 2);
imshow(im2);
hold on;
scatter(Xproj2(1, :), Xproj2(2, :), 'o', 'r');
scatter(x2(1, :), x2(2, :), '.', 'g');
axis equal;
legend('X projection 2', 'SIFT points 2');
title('Matching Points');
hold off;


% Good Matching Points
figure(2);
subplot(1, 2, 1);
imshow(im1);
hold on;
scatter(goodXproj1(1, :), goodXproj1(2, :), 'o', 'r');
scatter(goodx1(1, :), goodx1(2, :), '.', 'g');
axis equal;
legend('good X projection 1', 'good SIFT points 1');
title('Good Matching Points');
hold off;

subplot(1, 2, 2);
imshow(im2);
hold on;
scatter(goodXproj2(1, :), goodXproj2(2, :), 'o', 'r');
scatter(goodx2(1, :), goodx2(2, :), '.', 'g');
axis equal;
legend('good X projection 2', ' good SIFT points 2');
hold off;


% 3D Good Points triangulated with K[R | t]
figure(3);
plot3(goodX(1, :), goodX(2, :), goodX(3, :), 'r.')
xlabel x;
ylabel y;
zlabel z;
axis equal;
grid on;
legend('Good Points triangulated with K[R | t]');


% Points Normalized with K^-1
figure(4);
subplot(1, 2, 1);
imshow(im1);
hold on;
scatter(Xproj1_(1, :), Xproj1_(2, :), 'o', 'r');
scatter(x1(1, :), x1(2, :), '.', 'g');
axis equal;
legend('X projection 1', 'SIFT points 1');
title('Points Normalized with K^{-1}');
hold off;

subplot(1, 2, 2);
imshow(im2);
hold on;
scatter(Xproj2_(1, :), Xproj2_(2, :), 'o', 'r');
scatter(x2(1, :), x2(2, :), '.', 'g');
axis equal;
legend('X projection 1', 'SIFT points 1');
hold off;


% Good Points Normalized with K^-1
figure(5);
subplot(1, 2, 1);
imshow(im1);
hold on;
scatter(goodXproj1_(1, :), goodXproj1_(2, :), 'o', 'r');
scatter(goodx1(1, :), goodx1(2, :), '.', 'g');
axis equal;
legend('good X projection 1', 'good SIFT points 1');
title('Good Points Normalized with K^{-1}');
hold off;

subplot(1, 2, 2);
imshow(im2);
hold on;
scatter(goodXproj2_(1, :), goodXproj2_(2, :), 'o', 'r');
scatter(goodx2(1, :), goodx2(2, :), '.', 'g');
axis equal;
legend('good X projection 2', 'good SIFT points 2');
hold off;

% 3D Good Points triangulated with [R | t]
figure(6);
plot3(goodX_(1, :), goodX_(2,:), goodX_(3,:), 'b.');
xlabel x;
ylabel y;
zlabel z;
axis equal;
grid on;
legend('Good Points triangulated with [R | t]');
