function F = convert_E_to_F(E,K1,K2)
    F = (K2^(-1))' * E * K1^(-1);
end