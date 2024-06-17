function flatten = pflat(points)
    numRows = size(points, 1); 
    lastCoordinates = points(numRows, :); 
    for i = 1:numRows
        points(i, :) = points(i, :) ./ lastCoordinates;
    end
    flatten = points;
end