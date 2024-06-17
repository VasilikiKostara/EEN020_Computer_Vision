function X = triangulate_3D_point_DLT(camera1, camera2, points1, points2)

    P1 = camera1(1, :);
    P2 = camera1(2, :);
    P3 = camera1(3, :);
    Q1 = camera2(1, :);
    Q2 = camera2(2, :);
    Q3 = camera2(3, :);

    x1 = points1(1, :);
    y1 = points1(2, :);
    x2 = points2(1, :);
    y2 = points2(2, :); 

    n_points = size(points1, 2);
    X = [];

    for i = 1:n_points
        A = [P1 - x1(i) * P3; P2 - y1(i) * P3; Q1 - x2(i) * Q3; Q2 - y2(i) * Q3];
        %A = [camera1 -[points1(:,i); 1] [0 0 0]' ; camera2 [0 0 0]' -[points2(:,i); 1]];
        [~, ~, V] = svd(A);
        minEigenvector = V(:, size(V, 2));    
        X = [X minEigenvector(1:4,:)];
    end

end