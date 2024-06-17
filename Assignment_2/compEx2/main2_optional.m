clc;

% Load
whos("-file", "compEx3data.mat");
data = load("compEx3data.mat", "Xmodel", "endind", "startind", "x");

X = data.Xmodel;
X = [X; ones(1, size(X, 2))];
x = data.x;   % already flattened

x1 = x{1};
n = size(x1, 2);
sample = [x1(:, 1) x1(:, 4) x1(:, 13) x1(:, 16) x1(:, 25) x1(:, 28) x1(:, 31)];
n_sample = size(sample, 2);

% NORMALIZED
mean1 = mean(x1(1:2, :), 2);
std1 = std(x1(1:2, :),0 , 2);
std1x = std1(1);
std1y = std1(2);
mean1x = mean1(1);
mean1y = mean1(2);
N1 = [1/std1x 0 -mean1x/std1x; 0 1/std1y -mean1y/std1y; 0 0 1];
normalized = N1 * x1;
[minEigenvalue1, minEigenvector1, norm_Mv1] = estimate_camera_DLT(X, normalized);
P1 = reshape(minEigenvector1(1:12) ,[4 3])'; 
P1_ = N1^(-1) * P1; 
proj1 = pflat(P1_ * X);
dx1 = x1 - proj1;

%only points number 1; 4; 13; 16; 25; 28; 31
sample_proj1 = [proj1(:, 1) proj1(:, 4) proj1(:, 13) proj1(:, 16) proj1(:, 25) proj1(:, 28) proj1(:, 31)];
dx_sample1 = sample - sample_proj1;

% Frobenius norm
eRMS1 = sqrt((norm(dx1,'fro').^2) / n)
eRMS_sample1 = sqrt((norm(dx_sample1,'fro').^2) / n_sample)



% UNNORMALIZED
[minEigenvalue2, minEigenvector2, norm_Mv2] = estimate_camera_DLT(X, x1);
P2 = reshape(minEigenvector2(1:12) ,[4 3])'; 
proj2 = pflat(P2 * X);
dx2 = x1 - proj2;

%only points number 1; 4; 13; 16; 25; 28; 31
sample_proj2 = [proj2(:, 1) proj2(:, 4) proj2(:, 13) proj2(:, 16) proj2(:, 25) proj2(:, 28) proj2(:, 31)];
dx_sample2 = sample - sample_proj2;

% Frobenius norm
eRMS2 = sqrt((norm(dx2,'fro').^2) / n)
eRMS_sample2 = sqrt((norm(dx_sample2,'fro').^2) / n_sample)
