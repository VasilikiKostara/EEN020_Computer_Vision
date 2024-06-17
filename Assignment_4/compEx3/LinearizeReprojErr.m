function [r, J] = LinearizeReprojErr(P1, P2, Xj, x1j, x2j)

    p1 = P1(1, :);
    p2 = P1(2, :);
    p3 = P1(3, :);
    
    q1 = P2(1, :);
    q2 = P2(2, :);
    q3 = P2(3, :);

    [~,r] = ComputeReprojectionError(P1, P2, Xj, x1j, x2j);    

    j1 = [p1 * Xj * p3 / (p3 * Xj)^2 - p1 / (p3 * Xj);
          p2 * Xj * p3 / (p3 * Xj)^2 - p2 / (p3 * Xj)];
    j2 = [q1 * Xj * q3 / (q3 * Xj)^2 - q1 / (q3 * Xj);
          q2 * Xj * q3 / (q3 * Xj)^2 - q2 / (q3 * Xj)];
    
    J = [j1; j2];
end