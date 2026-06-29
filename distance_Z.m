function [z] = distance_Z(Coords, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(:, 3).*h0' - Normal_orth(:, 1)* Coords(:, 1)' - Normal_orth(:, 2)*Coords(:, 2)')./Normal_orth(:, 3);
end
