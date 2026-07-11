function [energy_refr, dist_need, index_plane] = trace(aperture, normals, h_0, energy_inc, ismin)
    
    energy_refr = zeros(1, size(h_0, 2));
    
    dist_beam = distance_Z(aperture, normals, h_0);
    
    if ismin
        [dist, index_plane] = min (dist_beam);
    else
        [dist, index_plane] = max (dist_beam);
    end
    N = sqrt(size(aperture, 1));
    dist_need = reshape(dist, N, N);

    for i = 1:size(energy_inc, 2)
        energy_refr(1, index_plane(1, i)) = energy_inc(1, i) + energy_refr(1, index_plane(1, i));
    end
end