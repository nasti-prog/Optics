function [energy_inc, energy_req] = fresnel(flux, energy_req, inc_beams, refr_beams, n1, n2, p_0, p1, normals)
    fresnel_loss = 1 - T(n1, n2, p_0, p1, normals, "unpol")';
    energy_loss = fresnel_loss .* energy_req;
    flux_i = sum(energy_loss) + flux;
    energy_inc = (1/inc_beams) .* (flux_i) .* ones(1, inc_beams);                           
    energy_req = (1/refr_beams) .* (flux.*ones(1, refr_beams)) + energy_loss;
    %energy_req = energy_req + energy_loss;
    %energy_full = (circle_mask) .* (flux_i) .* (1/refr_beams);

    % Amplitude
    function [t] = t(n1, n2, incident, refracted, normal, type)
    betta_inc = angle(incident, normal);
    betta_refr = angle(refracted, normal);
        if (type == 'p')
            t = 2.*n1.* cosd(betta_inc) ./ (n2.* cosd(betta_inc) + n1.* cosd(betta_refr) ); %p
        else
            t = 2.*n1.* cosd(betta_inc) ./ (n1.* cosd(betta_inc) + n2.* cosd(betta_refr) ); %s
        end
    end
    
    % Energy
    function [T] = T(n1, n2, incident, refracted, normal, type)
    betta_inc = angle(incident, normal);
    betta_refr = angle(refracted, normal);
        if type == 'p'
            T = (n2.*cosd(betta_refr)./(n1*cosd(betta_inc)))* abs( t(n1, n2, incident, refracted, normal, "p") )^2; %p
        elseif type == 's'
            T = (n2.*cosd(betta_refr)./(n1*cosd(betta_inc)))* abs( t(n1, n2, incident, refracted, normal, "s") )^2; %s
        else
            T = (n2.*cosd(betta_refr)./(n1.*cosd(betta_inc))).* 0.5 .* (abs( t(n1, n2, incident, refracted, normal, "s") ).^2 + abs( t(n1, n2, incident, refracted, normal, "p") ).^2); %unpolarized
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