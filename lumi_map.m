function [] = lumi_map(Matrix, count, Error, alpha, h)
    rows = sqrt(length(Matrix));
    Matr = reshape(Matrix, rows, rows)'; % into square-matr by rows
    imagesc(Matr)
    colorbar
    colormap(gray)                       % color range: jet - rainbow
    title_add = sprintf('Count: %d, Error: %.4f, Alpha: %.5f, h_0: %.4f', count, Error, alpha, h);
    title('Display', title_add);
    drawnow
    pause(1e-10)
end