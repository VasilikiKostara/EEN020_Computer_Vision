function P = extract_P_from_E(E)

    [U, ~, V] = svd(E);
    W = [0 -1 0; 1 0 0; 0 0 1];

    if det(U * V') < 0
        V = -V;
    end

    A1 = U * W * V'; 
    A2 = U * W' * V'; 
    u = U(:, 3);

    P2 = [A1 u];
    P3 = [A1 -u];
    P4 = [A2 u];
    P5 = [A2 -u];

    P = {P2, P3, P4, P5};
end