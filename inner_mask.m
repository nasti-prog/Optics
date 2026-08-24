u_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;       
v_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;
[U, V] = meshgrid(u_square, v_square);
r_inner = (size_disp/2 - length(u_square) * 5)
r_outer = (length(u_square) * 5)
%circle_mask = (U.^2 + V.^2) <= (size_disp/2)^2;
circle_inner_mask = ~( ( r_inner^2 <= (U.^2 + V.^2) ) & ( (U.^2 + V.^2) <= r_outer^2 ) );

u = U(circle_inner_mask);
v = V(circle_inner_mask);
refr_beams = length(v);                         
display = [u(:), v(:)];