function [convex_function, deviation] = convex_func (matr_req, matr_refr, h_0)
    convex_function = sum(matr_refr) - sum(h_0 .* matr_req);
    deviation = matr_refr - matr_req;
end