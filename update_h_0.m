<<<<<<< HEAD
function [h_0] = update_h_0(ismin, alpha, h_0, matr_req, matr_refr)
    if ismin
        h_0 = h_0 - alpha * (matr_req - matr_refr);
    else
        h_0 = h_0 + alpha * (matr_req - matr_refr);
    end
=======
function [h_0] = update_h_0(ismin, alpha, h_0, matr_req, matr_refr)
    if ismin
        h_0 = h_0 - alpha * (matr_req - matr_refr);
    else
        h_0 = h_0 + alpha * (matr_req - matr_refr);
    end
>>>>>>> 47cd48257b104dc7b5e901879d38e70df5f4d28d
end