function plot_points_3D(points)
    x = points(1, :);
    y = points(2, :);
    z = points(3, :);    
    scatter3(x, y, z, 'o', 'filled');    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title('3D Points Plot');
    grid on;
    axis equal;
end
