function [Energy_refr] = trace(Aperture, Normals, h_0, Energy_inc, Ismin)
    
    Energy_refr = zeros(1, size(h_0, 2));
    
    Dist_beam = distance_Z(Aperture, Normals, h_0);
    
    if Ismin
        [Dist_need, Index_plane] = min (Dist_beam);
    else
        [Dist_need, Index_plane] = max (Dist_beam);
    end
        
    for i = 1:size(Energy_inc, 2)
        Energy_refr(1, Index_plane(1, i)) = Energy_inc(1, i) + Energy_refr(1, Index_plane(1, i));
    end

    function [z] = distance_Z(Coords, Normal, h0)
        Normal_orth = get_orth(Normal);
        z = (Normal_orth(:, 3).*h0' - Normal_orth(:, 1)* Coords(:, 1)' - Normal_orth(:, 2)*Coords(:, 2)')./Normal_orth(:, 3);
    end

    function [orth] = get_orth (matrix)
    orth = zeros(size(matrix, 1), size(matrix, 2));
        for e = 1 : size(matrix, 1)
            len = sqrt(dot(matrix(e, :), matrix(e, :)));
            orth(e, :) = matrix(e, :)/len;
        end
    end
end

