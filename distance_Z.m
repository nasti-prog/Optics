function [z] = distance_Z(coords, normal, h0)
    normal_orth = get_orth(normal);
    z = (normal_orth(:, 3).*h0' - normal_orth(:, 1)* coords(:, 1)' - normal_orth(:, 2)*coords(:, 2)')./normal_orth(:, 3);
    
    function [orth] = get_orth (matrix)
        orth = zeros(size(matrix, 1), size(matrix, 2));
        for e = 1 : size(matrix, 1)
           len = sqrt(dot(matrix(e, :), matrix(e, :)));
           orth(e, :) = matrix(e, :)/len;
        end
    end
end
