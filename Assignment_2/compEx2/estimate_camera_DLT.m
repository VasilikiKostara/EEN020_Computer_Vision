function  [minEigenvalue, minEigenvector, norm_Mv] = estimate_camera_DLT(X, x)

n_points = size(X, 2);          % 37
X_dims = size(X, 1);            % 4
x_dims = size(x, 1);            % 3

% Form M
A= zeros(x_dims * n_points, x_dims * X_dims);     % (3*37, 12)
B= zeros(x_dims * n_points, x_dims);              % (3*37, 3)
for i=1:n_points
    A(((i-1) * x_dims + 1), 1:4) = X(:,i)';
    A(((i-1) * x_dims + 2), 5:8) = X(:,i)';
    A(((i-1) * x_dims + 3), 9:12) = X(:,i)';
    B(((i-1) * x_dims + 1), i) = -x(1,i)';
    B(((i-1) * x_dims + 2), i) = -x(2,i)';
    B(((i-1) * x_dims + 3), i) = -x(3,i)';
end
M=[A B];

% Solve least squares system
[~, S, V] = svd(M);
STS=(S'* S);
minEigenvalue = STS(size(STS, 1),size(STS, 2));
minEigenvector = V(:, size(V, 2));
norm_Mv = norm(minEigenvalue * minEigenvector);
end