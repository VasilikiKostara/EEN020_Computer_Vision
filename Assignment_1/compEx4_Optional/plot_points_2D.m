function plot_points_2D(points)
    x = points(1, :);
    y = points(2, :);    
    scatter(x, y, 'o', 'filled');
    grid on;
    axis on;
    axis equal;
end
