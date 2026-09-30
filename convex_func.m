function [deviation] = convex_func (matr_req, matr_refr, h_0)
    deviation = sum (h_0.*matr_req - matr_refr);
end