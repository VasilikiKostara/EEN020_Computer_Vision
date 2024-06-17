function coef = coefficients(points)
    P1 = points(:, 1);    
    x1 = P1(1);
    y1 = P1(2);
    
    P2 = points(:, 2);
    x2 = P2(1);
    y2 = P2(2);

    % Line equation in 2D: ax + by + c = 0
    a = y2 - y1;
    b = x1 - x2;
    c = x2 * y1 - x1 * y2;

    coef = [a; b; c];
    
end    