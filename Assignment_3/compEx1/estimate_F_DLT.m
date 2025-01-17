function [Fn, minEigenvalue, norm_Mv] = estimate_F_DLT(x1s, x2s)
    
    n_points = size(x1s, 2);
    M = zeros(n_points, 9);
    
    for i = 1:n_points
        M(i, 1) = x1s(1, i) * x2s(1, i);
        M(i, 2) = x1s(1, i) * x2s(2, i);
        M(i, 3) = x1s(1, i) * x2s(3, i);
    
        M(i, 4) = x1s(2, i) * x2s(1, i);
        M(i, 5) = x1s(2, i) * x2s(2, i);
        M(i, 6) = x1s(2, i) * x2s(3, i);
    
        M(i, 7) = x1s(3, i) * x2s(1, i);
        M(i, 8) = x1s(3, i) * x2s(2, i);
        M(i, 9) = x1s(3, i) * x2s(3, i); 
    end
    
    [~, S, V] = svd(M);
    STS=(S'* S);
    minEigenvalue = STS(size(STS, 1),size(STS, 2));
    minEigenvector = V(:, size(V, 2));
    norm_Mv = norm(M * minEigenvector);
    Fn = reshape(minEigenvector ,[3 3]);
end