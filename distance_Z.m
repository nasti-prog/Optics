function [z] = distance_Z(Coords, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(:, 3).*h0' - Normal_orth(:, 1)* Coords(:, 1)' - Normal_orth(:, 2)*Coords(:, 2)')./Normal_orth(:, 3);
    
    function [orth] = get_orth (matrix)
        orth = zeros(size(matrix, 1), size(matrix, 2));
        for e = 1 : size(matrix, 1)
           len = sqrt(dot(matrix(e, :), matrix(e, :)));
           orth(e, :) = matrix(e, :)/len;
        end
    end
end
