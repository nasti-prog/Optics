function [] = rings()
    u_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;       
    v_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;
    [U, V] = meshgrid(u_square, v_square);
    area = U.^2 + V.^2;
    length(u_square)
    r_outer = (size_disp/2 - length(u_square) * 3.5)
    r_inner = (length(u_square) * 4.5)
    circle_mask = ( (area <= (size_disp/2)^2) ) & ~( (r_inner^2 <= area) & (area <= r_outer^2) );
    imagesc(circle_mask)
    u = U(circle_mask);
    v = V(circle_mask);
    refr_beams = length(v);                         
    display = [u(:), v(:)];

    
    u_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;       
    v_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;
    step = size_disp/(n_disp-1);
    [U, V] = meshgrid(u_square, v_square);
    area = U.^2 + V.^2;
    center = -size_disp/2 + (n_disp/2)* size_disp/(n_disp-1);
    mask = ((U==center)|(V==center)) & (area <=(5*step)^2); 
    imagesc(mask)
    axis equal
    u = U(mask);
    v = V(mask);
    refr_beams = length(v);                         
    display = [u(:), v(:)];

end