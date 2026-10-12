function [] = lumi_map(matrix, count, error, alpha, mask)
    matr = zeros(size(mask));
    matr(mask) = matrix;
    imagesc(matr);
    colorbar;
    axis equal;
    axis image tight;
    colormap(gray);                       % color range: jet - rainbow
    title_add = sprintf('Count: %d, RRMSE: %.2f%%, Alpha: %.3f', count, error, alpha);
    title('Display', title_add);
    drawnow;
    pause(1e-10);
end

%rows = sqrt(length(matrix));
%matr = reshape(matrix, rows, rows)'; % into square-matr by rows