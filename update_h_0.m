function [h_0] = update_h_0(ismin, alpha, h_0, matr_req, matr_refr)
    if ismin
        h_0 = h_0 - alpha * (matr_req - matr_refr);
    else
        h_0 = h_0 + alpha * (matr_req - matr_refr);
    end
end