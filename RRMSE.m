function [rrmse] = RRMSE(Matr_req, Matr_refr)
rrmse = ( rmse(Matr_req, Matr_refr) / (sum(Matr_req)/length(Matr_req)) )*100;
end

