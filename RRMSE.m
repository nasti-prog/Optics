function [rrmse_percent] = rrmse(matr_req, matr_refr)
    rrmse_percent = ( rmse(matr_req, matr_refr) / (sum(matr_req)/length(matr_req)) )*100;
end