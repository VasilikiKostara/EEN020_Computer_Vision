function project_and_plot(P, Xs, image)

    proj = pflat(P * Xs);
    x = proj(1, :);
    y = proj(2, :);    
    
    imshow(image);
    hold on;
    plot(x, y, '.');
    axis equal;
    grid on;
    hold off;
end