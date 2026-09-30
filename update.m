function [h_0, alpha, RRMSE, convex_f_error] = update(structure, h_0, alpha, iter, mask)
    aperture = structure.aperture;
    normals = structure.normals;
    matr_inc = structure.matr_inc;
    matr_req = structure.matr_req;
    ismin = structure.ismin;
    RRMSE = zeros(1, iter);
    convex_f_error = zeros(1, iter);
    
    for count = 1:iter    
        matr_refr = trace(aperture, normals, h_0, matr_inc, ismin);
          
        RRMSE(1, count) = rrmse(matr_req, matr_refr);
        convex_f_error(1, count) = convex_func (matr_req, matr_refr, h_0);

        h_0 = update_h_0(ismin, alpha, h_0, matr_req, matr_refr);

        subplot(2, 1, 1)
        lumi_map(matr_refr, count, RRMSE(1, count), convex_f_error(1, count), alpha, mask)
     end
     subplot(2, 1, 2)
     plot(RRMSE)
end