function [] = lumi_map(matrix, count, error, alpha)
    rows = sqrt(length(matrix));
    matr = reshape(matrix, rows, rows)'; % into square-matr by rows
    imagesc(matr)
    colorbar
    colormap(gray)                       % color range: jet - rainbow
    title_add = sprintf('Count: %d, Error: %.4f, Alpha: %.5f', count, error, alpha);
    title('Display', title_add);
    drawnow
    pause(1e-10)
end