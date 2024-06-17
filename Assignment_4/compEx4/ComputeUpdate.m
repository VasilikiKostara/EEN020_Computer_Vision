function delta_X = ComputeUpdate(r, J, mu)

    dim = size(J, 2);
    I = eye(dim);
    
    C = J.'* J + mu * I;
    c = J.'* r;
    delta_X = -C\c;
end