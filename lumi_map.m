function [] = lumi_map(matrix, count, error, convex_f_error, alpha, mask)
    matr = zeros(size(mask));
    matr(mask) = matrix;
    imagesc(matr);
    colorbar;
    axis equal;
    colormap(gray);                       % color range: jet - rainbow
    title_add = sprintf('Count: %d, RRMSE: %.2f%%, Deviation of convex func: %.3f, Alpha: %.3f', ...
        count, error, convex_f_error, alpha);
    title('Display', title_add);
    drawnow;
    pause(1e-10);
end

%rows = sqrt(length(matrix));
%matr = reshape(matrix, rows, rows)'; % into square-matr by rows