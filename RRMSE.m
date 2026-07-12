function [rrmse] = RRMSE(matr_req, matr_refr)
rrmse = ( rmse(matr_req, matr_refr) / (sum(matr_req)/length(matr_req)) )*100;
end

