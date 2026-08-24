function [] = lumi_map(matrix, count, error, alpha, u_square, circle_mask)
    %rows = sqrt(length(matrix));
    %matr = reshape(matrix, rows, rows)'; % into square-matr by rows

    matr = zeros(size(u_square, 2));
    matr(circle_mask) = matrix;
    imagesc(matr);
    colorbar;
    axis equal;
    colormap(gray);                       % color range: jet - rainbow
    title_add = sprintf('Count: %d, Error: %.4f, Alpha: %.5f', count, error, alpha);
    title('Display', title_add);
    drawnow;
    pause(1e-10);
end