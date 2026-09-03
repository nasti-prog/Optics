function [energy_req, flux] = fresnel(flux, energy_req, n1, n2, p_0, p1, normals)
    fresnel_loss = 1 - T(n1, n2, p_0, p1, normals, "unpol")';
    fresnel_unloss = T(n1, n2, p_0, p1, normals, "unpol")';
    energy_req = energy_req ./ fresnel_unloss;
    flux = sum(energy_req.*fresnel_loss) + flux;
    
    % Amplitude
    function [t_amp] = t(n1, n2, incident, refracted, normal, type)
        betta_inc = angle(incident, normal);
        betta_refr = angle(normal, refracted);
        if (type == 'p')
            t_amp = (2.*n1.* cosd(betta_inc)) ./ (n2.* cosd(betta_inc) + n1.* cosd(betta_refr) ); %p
        else
            t_amp = (2.*n1.* cosd(betta_inc)) ./ (n1.* cosd(betta_inc) + n2.* cosd(betta_refr)); %s
        end
    end
    % Energy
    function [T_en] = T(n1, n2, incident, refracted, normal, type)
        betta_inc = angle(incident, normal);
        betta_refr = angle(normal, refracted);
        if type == 'p'
            T_en = (n2.*cosd(betta_refr)./(n1.*cosd(betta_inc))).* (abs( t(n1, n2, incident, refracted, normal, "p") ).^2); %p
        elseif type == 's'
            T_en = (n2.*cosd(betta_refr)./(n1.*cosd(betta_inc))).* (abs( t(n1, n2, incident, refracted, normal, "s") ).^2); %s
        else
            T_en = (n2.*cosd(betta_refr)./(n1.*cosd(betta_inc))).* 0.5 .* ( (abs( t(n1, n2, incident, refracted, normal, "s") ).^2) + (abs( t(n1, n2, incident, refracted, normal, "p") ).^2) ); %unpolarized
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
    
    % Angle by row
    function [alpha] = angle(mat1, mat2)
        m1 = get_orth(mat1);    m2 = get_orth(mat2);
        alpha = zeros(size(mat1, 1),1);
        for e = 1 : size(mat1, 1)
            alpha(e, :) = acosd(dot(m1(e, :), m2(e, :), 2));
        end
    end
end