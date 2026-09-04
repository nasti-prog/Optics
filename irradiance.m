function [relative_irr] = irradiance (p_0, normals, l, size_disp)
    r1 =  sqrt(l^2 + (size_disp^2/2));  %расстояние до крайней точки
    r2 = l;
    inc_val = angle(p_0(1, :), normals(1, :));
    tetta1 = sind( n1 .* sind(inc_val) );
    relative_irr = cosd(tetta1) * (r2/r1)^2;

    % Angle by row
    function [alpha] = angle(mat1, mat2)
        m1 = get_orth(mat1);    m2 = get_orth(mat2);
        alpha = zeros(size(mat1, 1),1);
        for e = 1 : size(mat1, 1)
            alpha(e, :) = acosd(dot(m1(e, :), m2(e, :), 2));
        end
    end
    
    % Create orth from a vector
    function [orth] = get_orth (matrix)
    orth = zeros(size(matrix, 1), size(matrix, 2));
        for e = 1 : size(matrix, 1)
            len = sqrt(dot(matrix(e, :), matrix(e, :)));
            orth(e, :) = matrix(e, :)/len;
        end
    end
end