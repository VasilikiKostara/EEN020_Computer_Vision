function plot_points(points, style)
    if nargin == 1
        style = '-';
    end
    x = points(1, :);
    y = points(2, :);    
    scatter(x, y, 'o', 'filled');
end