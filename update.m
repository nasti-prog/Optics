function [h_0, alpha, Error] = update(aperture, normals, h_0, matr_inc, matr_req, ismin, alpha, iter)   
    for count = 1:iter    
        matr_refr = trace(aperture, normals, h_0, matr_inc, ismin);
            
        Error(1, count) = RRMSE(matr_req, matr_refr);
                
        h_0 = update_h_0(ismin, alpha, h_0, matr_req, matr_refr);
            
        subplot(2, 1, 1)
        lumi_map(matr_refr, count, Error(1, count), alpha, h_0(1,1) )
     end
     subplot(2, 1, 2)
     plot(Error)
end