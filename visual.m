function [] = visual(aperture, normals, h_0, matr_inc, matr_req, ismin, alpha, normal, h)
    subplot(2, 1, 1)
    matr_refr = trace(aperture, normals, h_0, matr_inc, ismin);
    rows = sqrt(length(matr_refr));
    matr = reshape(matr_refr, rows, rows)'; % into square-matr by rows
    imagesc(matr)
    colorbar
    colormap(gray)                       % color range: jet - rainbow
    title_add = sprintf('RRMSE: %.4f, Alpha: %.5f', RRMSE(matr_req, matr_refr), alpha);
    title('Display', title_add);
    drawnow
    pause(1e-10)

    subplot(2, 1, 2)
    visual_plane(normal, h);

    function [] = visual_plane(normal, h0)
        x = 0:1:5;
        y = 0:1:5;
        z = ( - normal(1, 1) * x - normal(1, 2) * y + normal(1, 3) * h0 ) / normal(1, 3);
        plot(x, z);  
    end
end