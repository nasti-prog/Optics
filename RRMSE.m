<<<<<<< HEAD
function [rrmse] = RRMSE(matr_req, matr_refr)
rrmse = ( rmse(matr_req, matr_refr) / (sum(matr_req)/length(matr_req)) )*100;
end

=======
function [rrmse] = RRMSE(matr_req, matr_refr)
rrmse = ( rmse(matr_req, matr_refr) / (sum(matr_req)/length(matr_req)) )*100;
end

>>>>>>> 47cd48257b104dc7b5e901879d38e70df5f4d28d
