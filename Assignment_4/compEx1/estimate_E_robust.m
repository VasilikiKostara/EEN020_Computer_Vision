function [E, inliers1, inliers2, eRMS] = estimate_E_robust(K, x1, x2)

    pixels  = 2;
    threshold = pixels / K(1 ,1);

    norm1 = pflat(K^(-1) * x1);
    norm2 = pflat(K^(-1) * x2);

    accuracy = 0.9999;
    epsilon = 0.1;
    n_indices = 8;
    n_points = size(x1, 2);
    T = log10(1-accuracy)/log10(1 - epsilon^n_indices);
    
    random_indices = randperm(n_points, n_indices);
    random_points1 = norm1(:, random_indices);
    random_points2 = norm2(:, random_indices);
    [E_approx, ~, ~] = estimate_F_DLT(random_points1, random_points2);
    [E, ~] = enforce_essential(E_approx);
    [~, d1, ~] = compute_epipolar_errors(E', norm2, norm1);
    [~, d2, ~] = compute_epipolar_errors(E, norm1, norm2);

    while T > 0
        temp_indices = randperm(n_points, n_indices);
        temp_points1 = norm1(:, temp_indices);
        temp_points2 = norm2(:, temp_indices);
        [tempE_approx, ~, ~] = estimate_F_DLT(temp_points1, temp_points2);
        [tempE, ~] = enforce_essential(tempE_approx);
        [~, temp_d1, ~] = compute_epipolar_errors(tempE', norm2, norm1);
        [~, temp_d2, ~] = compute_epipolar_errors(tempE, norm1, norm2);
    
        tempInliers = (temp_d1.^2 + temp_d2.^2) / 2 < threshold ^2;
        nInliers = sum(tempInliers);
        tempEpsilon = nInliers / n_points;
        
        if tempEpsilon > epsilon 
            epsilon = tempEpsilon;
            T = log10(1-accuracy)/log10(1 - epsilon^n_indices);
            d1 = temp_d1;
            d2 = temp_d2;
            inliers1 = x1(:, tempInliers);
            inliers2 = x2(:, tempInliers);
            E = tempE;
        end
        T = T-1;
    end
    E = E/E(end);
    eRMS = sqrt(0.5 * sum(d1.^2 + d2.^2) / n_points);
end

