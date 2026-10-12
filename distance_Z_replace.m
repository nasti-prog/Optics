function [z] = distance_Z_replace(aperture, display_replace, h_0)
    z = display_replace(:, 1) .* aperture(:, 1)' + display_replace(:, 2) .* aperture(:, 2)' + repmat(h_0', 1, size(aperture, 1));
end