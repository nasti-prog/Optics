function [] = lumi_map(matrix, count, error, alpha, size_disp, n_disp)
    %rows = sqrt(length(matrix));
    %matr = reshape(matrix, rows, rows)'; % into square-matr by rows
    u_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;       
    v_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;
    [U, V] = meshgrid(u_square, v_square);
    circle_mask = (U.^2 + V.^2) <= (size_disp/2)^2;
    matr = zeros(size(U));
    matr(circle_mask) = matrix;
    imagesc(matr)
    colorbar
    colormap(gray)                       % color range: jet - rainbow
    title_add = sprintf('Count: %d, Error: %.4f, Alpha: %.5f', count, error, alpha);
    title('Display', title_add);
    drawnow
    pause(1e-10)
end