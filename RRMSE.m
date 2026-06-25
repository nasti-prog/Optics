function [RRMSE] = RRMSE(Matr_req, Matr_refr)
RRMSE = ( rmse(Matr_req, Matr_refr) / (sum(Matr_req)/length(Matr_req)) )*100;
end

