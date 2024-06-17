clc;

% Load
whos("-file", "compEx3data.mat");
data = load("compEx3data.mat", "Xmodel", "endind", "startind", "x");

X = data.Xmodel;
X = [X; ones(1, size(X, 2))];
endind = data.endind;
startind = data.startind;
x = data.x;   % already flattened

% CUBE 1
imPath1 = 'cube1.jpg';
im1 = imread(imPath1);
x1 = x{1};

mean1 = mean(x1(1:2, :), 2);
std1 = std(x1(1:2, :),0 , 2);
std1x = std1(1);
std1y = std1(2);
mean1x = mean1(1);
mean1y = mean1(2);

N1 = [1/std1x 0 -mean1x/std1x; 0 1/std1y -mean1y/std1y; 0 0 1];

normalized1 = N1 * x1;
mean_normalized1 = mean(normalized1(1:2, :), 2);
std_normalized1 = std(normalized1(1:2, :),0 , 2);

[minEigenvalue1, minEigenvector1, norm_Mv1] = estimate_camera_DLT(X, normalized1);
lamda1 = minEigenvalue1;
Mv1 = norm_Mv1;
P1 = reshape(-minEigenvector1(1:12) ,[4 3])'; 
P1_ = N1^(-1) * P1; 
proj1 = pflat(P1_ * X);

[K1, Rt1] = rq(P1_);
k1 = K1 ./ K1(3, 3);

% CUBE 2
imPath2 = 'cube2.jpg';
im2= imread(imPath2);
x2 = x{2};

mean2 = mean(x2(1:2, :), 2);
std2 = std(x2(1:2, :), 0, 2);
std2x = std2(1);
std2y = std2(2);
mean2x = mean2(1);
mean2y = mean2(2);

N2 = [1/std2x 0 -mean2x/std2x; 0 1/std2y -mean2y/std2y; 0 0 1];

normalized2 = N2 * x2;
mean_normalized2 = mean(normalized2(1:2, :), 2);
std_normalized2 = std(normalized2(1:2, :),0 , 2);

[minEigenvalue2, minEigenvector2, norm_Mv2] = estimate_camera_DLT(X, normalized2);
lamda2 = minEigenvalue2;
Mv2 = norm_Mv2;
P2 = reshape(-minEigenvector2(1:12) ,[4 3])'; 
P2_ = N2^(-1) * P2; 
proj2 = pflat(P2_ * X);

[K2, Rt2] = rq(P2_);


% Save camera matrices P1_ and P2_
save('cube_cameras.mat','P1_','P2_')


% PLOTS
%
figure(1);
subplot(1, 2, 1);
scatter(normalized1(1, :), normalized1(2, :), 'o', "filled", "b");
hold on;
scatter(mean_normalized1(1), mean_normalized1(2), 'o', "filled");
rectangle('Position', [-2*std_normalized1(1) -2*std_normalized1(2) 4*std_normalized1(1) 4*std_normalized1(2)], 'Curvature', [1 1]);
rectangle('Position', [-1*std_normalized1(1) -1*std_normalized1(2) 2*std_normalized1(1) 2*std_normalized1(2)], 'Curvature', [1 1]);
axis([-3 3 -3 3])
axis square;
xlabel x;
ylabel y;
grid on;
legend('cube points', 'mean');
title('Cube 1');
hold off;

subplot(1, 2, 2);
scatter(normalized2(1, :), normalized2(2, :), 'o', "filled", 'p');
hold on;
scatter(mean_normalized2(1), mean_normalized2(2), 'o', "filled");
rectangle('Position', [-2*std_normalized2(1) -2*std_normalized2(2) 4*std_normalized2(1) 4*std_normalized2(2)], 'Curvature', [1 1]);
rectangle('Position', [-1*std_normalized2(1) -1*std_normalized2(2) 2*std_normalized2(1) 2*std_normalized2(2)], 'Curvature', [1 1]);
axis([-3 3 -3 3])
axis square;
xlabel x;
ylabel y;
grid on;
legend('cube points', 'mean');
title('Cube 2');
hold off;


%
figure(3);
x = [X(1, startind); X(1, endind)];
y = [X(2, startind); X(2, endind)];
z = [X(3, startind); X(3, endind)];  
scale = 20;
plot3(0,0,0,'w.');
hold on;
plot_camera(P1_, scale);
plot_camera(P2_, scale);
plot3(x, y, z, 'b.', 'MarkerSize', 20);
plot3(x, y, z, 'b-');
xlabel x;
ylabel y; 
zlabel z;
axis equal;
legend('', 'camera 1 axis', 'camera 1 center', 'camera 2 axis', 'camera 2 center', 'points');
grid on;
hold off;

%
figure(4);
subplot(1, 2, 1);
imshow(im1)
hold on;
plot(x1(1,:), x1(2,:), 'r.', 'MarkerSize', 20);
plot([proj1(1,startind); proj1(1,endind)], [proj1(2,startind); proj1(2,endind)], 'b.', 'MarkerSize', 10);
plot([proj1(1,startind); proj1(1,endind)], [proj1(2,startind); proj1(2,endind)], 'b-');
legend('x1', 'projection 1');
title('Projection 1');
hold off;

subplot(1, 2, 2);
imshow(im2)
hold on;
plot(x2(1,:), x2(2,:), 'r.', 'MarkerSize', 20);
plot([proj2(1,startind); proj2(1,endind)], [proj2(2,startind); proj2(2,endind)], 'g.', 'MarkerSize', 10);
plot([proj2(1,startind); proj2(1,endind)], [proj2(2,startind); proj2(2,endind)], 'g-');
legend('x2', 'projection 2');
title('Projection 2');
hold off;



