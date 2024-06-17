function [lines, distances, mean_distance] = compute_epipolar_errors(F, x1s, x2s)
    F = F./ F(3, 3);
    lines = F * x1s;
    lines = lines./ sqrt(repmat(lines(1 ,:).^2 + lines(2 ,:).^2 ,[3 1]));
    distances = abs(sum(lines.* x2s));
    mean_distance = mean(distances);
end