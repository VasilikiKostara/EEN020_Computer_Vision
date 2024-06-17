function [F, detF] = enforce_fundamental(F_approx)

    [U, S, V] = svd(F_approx);
    S(end, end) = 0;
    F = U * S * V';
    detF = det(F);
end