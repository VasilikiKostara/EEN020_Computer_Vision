function plot_camera(matrix, scale)
    [center, ax] = camera_center_and_axis(matrix);
    x0 = center(1);
    y0 = center(2);
    z0 = center(3);
    vx = ax(1);
    vy = ax(2);
    vz = ax(3);
    quiver3(x0, y0 ,z0 ,vx ,vy ,vz ,scale);
    scatter3(x0, y0, z0, 'o', 'filled');    
    axis equal;
end