function [max_angle_inc, max_angle_refr] = total_reflection(n1, p_0, normals)
    inc_val = angle(p_0, normals);
    sin_refracted = ( n1 .* sind(inc_val) );
    max_angle_inc = max(inc_val);
    max_angle_refr = max( asind(sin_refracted));
    count = 0;
    for i = 1:length (sin_refracted)
        if sin_refracted(i) > 1
            count = count + 1;
            fprintf('%d Angle: %1.3f - Полное внутреннее отражение\n', count, inc_val(i));       
        end
    end
    fprintf("Кол-во пво: %d\n", count);

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