function plot_points_3D(points)
    x = points(1, :);
    y = points(2, :);
    z = points(3, :);    
    scatter3(x, y, z, '.'); 
    axis equal;
end
