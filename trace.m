function [energy_refr, dist_need, index_plane] = trace(aperture, display, normals, h_0, energy_inc, ismin, iscartesian)
    
    energy_refr = zeros(1, size(h_0, 2));
    
    if iscartesian == false
        % replace coordi 
        dist_beam = distance_Z_replace(aperture, display, h_0);
    else
        % cartesian coordi
        dist_beam = distance_Z(aperture, normals, h_0);
    end

    if ismin
        [dist, index_plane] = min (dist_beam);
    else
        [dist, index_plane] = max (dist_beam);
    end

    n = size(aperture, 1);
    dist_need = reshape(dist, n, []);

    %s = sqrt(length(dist));
    %dist_need = reshape(dist, s, s);

    for i = 1:size(energy_inc, 2)
        energy_refr(1, index_plane(1, i)) = energy_inc(1, i) + energy_refr(1, index_plane(1, i));
    end
end