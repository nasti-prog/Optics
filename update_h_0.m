function [h_0] = update_h_0(Ismin, alpha, h_0, Matr_req, Matr_refr)
    if Ismin
        h_0 = h_0 - alpha * (Matr_req - Matr_refr);
    else
        h_0 = h_0 + alpha * (Matr_req - Matr_refr);
    end
end

