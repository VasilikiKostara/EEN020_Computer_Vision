function [center, axis] = camera_center_and_axis(matrix)
    col1 = matrix(:, 1);
    col2 = matrix(:, 2);
    col3 = matrix(:, 3);
    col4 = matrix(:, 4);
    
    x =  det([col2 col3 col4]);
    y = -det([col1 col3 col4]);
    z =  det([col1 col2 col4]);
    w = -det([col1 col2 col3]);

    c = [x; y; z; w];
    c = pflat(c);
    center = c(1:3);

    M = [col1 col2 col3];
    rowM3 = M(3, :);
    a = det(M) * rowM3;
    axis = a ./ norm(a);
end