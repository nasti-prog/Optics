function [h_0, alpha, matr_refr, dist, RRMSE_result, convex_result] = update(structure, h_0, alpha, iter, mask, RRMSE_result, convex_result)
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
        [matr_refr, dist, ~] = trace(aperture, display, normals, h_0, matr_inc, ismin, iscartesian);
        h_0 = update_h_0(ismin, alpha, h_0, matr_req, matr_refr);

        RRMSE(1, count) = rrmse(matr_req, matr_refr);
        convex_f(1, count) = convex_func(matr_req, matr_inc, h_0, dist);

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

    RRMSE_result = [RRMSE_result, RRMSE];
    convex_result = [convex_result, convex_f];
end