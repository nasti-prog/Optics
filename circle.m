size_aper = 5;
size_disp = 800;
n_aper = 48;
n_disp = 5;

x = -size_aper/2: size_aper/(n_aper-1) :size_aper/2;
y = -size_aper/2: size_aper/(n_aper-1) :size_aper/2;      
[X, Y] = meshgrid(x, y);
inc_beams = length(x)*length(y);                     
aperture = [X(:), Y(:)];

u_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;       
v_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;
[U, V] = meshgrid(u_square, v_square);
circle_mask = (U.^2 + V.^2) <= (size_disp/2)^2;
u = U(circle_mask);
v = V(circle_mask);
refr_beams = length(v);                         
display = [u(:), v(:)];

energy_inc = (1/inc_beams) * (flux) * ones(1, inc_beams);                           
energy_req = (1/refr_beams) * (flux) * ones(1, refr_beams);
imagesc(display)
colorbar

alpha_max = ((u(length(u)) - u(1))/length(u)) / (max(energy_req)*length(x));