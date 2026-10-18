function [convex_function, deviation] = convex_func(matr_req, matr_inc, h_0, z)
    convex_function = sum(z .* matr_inc) - sum(h_0 .* matr_req);
    deviation = sum(matr_inc) - sum(matr_req);
end