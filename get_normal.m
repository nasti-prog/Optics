function [Normal] = get_normal(n1, n2, inc_vec, ref_vec, inc_ang, ref_ang)
% incident beam - p0 - eд вектора
% refracted beam - p1
% Normal - ort, from 1 to 2 env
% правка!!!!!!!!!!!!!
Normal = ( (n2*ref_vec - n1*inc_vec) / (n2*cos(ref_ang) - n1*cos(inc_ang)) );
end