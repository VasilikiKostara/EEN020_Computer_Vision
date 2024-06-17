function plot_points_2D(points)

    x = points(1, :);
    y = points(2, :);    
    scatter(x, y, '.');
    grid on;
    axis equal;
end
