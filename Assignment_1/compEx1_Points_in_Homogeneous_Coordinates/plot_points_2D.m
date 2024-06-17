function plot_points_2D(points)
    x = points(1, :);
    y = points(2, :);    
    scatter(x, y, 'o', 'filled');
    xlabel('x');
    ylabel('y');
    title('2D Points Plot');
    grid on;
    axis equal;
end
