function d = point_line_distance_2D(point, coefficients)
    a = coefficients(1);
    b = coefficients(2);
    c = coefficients(3);
    x = point(1);
    y = point(2);
    numerator = abs(a * x + b * y + c);
    denominator = sqrt(a^2 + b^2);
    d = numerator / denominator;
end