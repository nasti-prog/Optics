function [h_0, alpha, Error] = update(Aperture, Normals, h_0, Matr_inc, Matr_req, Ismin, alpha, alpha_max, Iter)
    if (alpha <= alpha_max)
        alpha = alpha/4;
    end
    
    for count = 1:Iter                      % update of h_0
        
        Matr_refr = trace(Aperture, Normals, h_0, Matr_inc, Ismin);
    
        Error(1, count) = RRMSE(Matr_req, Matr_refr);
        
        h_0 = update_h_0(Ismin, alpha, h_0, Matr_req, Matr_refr);
    
        subplot(2, 1, 1)
        lumi_map(Matr_refr, count, Error(1, count), alpha, h_0(1,1) )
    end
    subplot(2, 1, 2)
    plot(Error)
    h_0 = h_0;
end