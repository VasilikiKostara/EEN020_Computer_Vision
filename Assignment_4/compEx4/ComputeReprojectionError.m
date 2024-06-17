function [err,res] = ComputeReprojectionError(P1, P2, Xj, x1j, x2j)

    p1 = P1(1, :);
    p2 = P1(2, :);
    p3 = P1(3, :);
    
    q1 = P2(1, :);
    q2 = P2(2, :);
    q3 = P2(3, :);

    r1 = [ x1j(1) - p1 * Xj / (p3 * Xj) ; 
           x1j(2) - p2 * Xj / (p3 * Xj) ];

    r2 = [ x2j(1) - q1 * Xj / (q3 * Xj) ; 
           x2j(2) - q2 * Xj / (q3 * Xj) ];
    
    res = [r1; r2];
    err = norm(r1)^2 + norm(r2)^2 ;
end