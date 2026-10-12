function [h_0, alpha, matr_refr, RRMSE, convex_f] = update(structure, h_0, alpha, iter, mask)
    aperture = structure.aperture;
    display = structure.display;
    normals = structure.normals;
    matr_inc = structure.matr_inc;
    matr_req = structure.matr_req;
    ismin = structure.ismin;
    iscartesian = structure.replace;
    RRMSE = zeros(1, iter);
    convex_f = zeros(1, iter);
    figure('Position', [100, 100, 900, 750])

    for count = 1:iter    
        matr_refr = trace(aperture, display, normals, h_0, matr_inc, ismin, iscartesian);
          
        RRMSE(1, count) = rrmse(matr_req, matr_refr);
        convex_f(1, count) = convex_func(matr_req, matr_refr, h_0);

        h_0 = update_h_0(ismin, alpha, h_0, matr_req, matr_refr);

        subplot(3, 1, 1)
        lumi_map(matr_refr, count, RRMSE(1, count), alpha, mask)
    end

    subplot(3, 1, 2)
    plot(RRMSE)
    title('RRMSE')
    grid on

    subplot(3, 1, 3)
    plot(convex_f)
    title('Convex function')
    grid on
end