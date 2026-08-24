%% Input data
p0 = [0, 0, 1];
l = 700;                                                   
n1 = 1.493;
n2 = 1;
iter = 500;                                                 
ismin = false;                                              
alpha = (1000E-2)/1.55;
flux = 1;

size_aper = 5;
size_disp = 800;
n_aper = 700;
n_disp = 70;

x = -size_aper/2: size_aper/(n_aper-1) :size_aper/2;
y = -size_aper/2: size_aper/(n_aper-1) :size_aper/2;      
[X, Y] = meshgrid(x, y);
inc_beams = length(x)*length(y);                     
aperture = [X(:), Y(:)];

u_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;       
v_square = -size_disp/2: size_disp/(n_disp-1) :size_disp/2;
[U, V] = meshgrid(u_square, v_square);
area = U.^2 + V.^2;
length(u_square)
r_inner = (size_disp/2 - length(u_square) * 3.5)
r_outer = (length(u_square) * 4.5)
circle_mask = ( (area <= (size_disp/2)^2) ) & ~( (r_inner^2 <= area) & (area <= r_outer^2) );
imagesc(circle_mask)
u = U(circle_mask);
v = V(circle_mask);
refr_beams = length(v);                         
display = [u(:), v(:)];

energy_inc = (1/inc_beams) * (flux) * ones(1, inc_beams);                          
energy_req = (1/refr_beams) * (flux) * ones(1, refr_beams);

%alpha_max = ((u(length(u)) - u(1))/length(u)) / (max(energy_req)*length(x));
p1 = [display(:, 1), display(:, 2), repmat(l, refr_beams, 1)];
p_0 = repmat(p0, refr_beams, 1);
normals = get_normal(n1, n2, p_0, p1);
h_0 = 8 + (11 - 8)*rand(1, refr_beams);
error = zeros(1, iter);

total_reflection(n1, p_0, normals);
%% Fresnel
[energy_inc, energy_req] = fresnel(flux, energy_req, inc_beams, refr_beams, n1, n2, p_0, p1, normals);
params = struct('aperture', aperture, 'normals', normals, 'matr_inc', energy_inc, 'matr_req', energy_req, 'ismin', ismin);
%% Calculation
[h_0, alpha, ~] = update(params, h_0, alpha, iter, error, u_square, circle_mask);
%% Export to Rhino
%export_surf2rhino(n, m, params, h_0, size_aper)
%% Visualising
%visual(params, h_0, alpha);
%% Functions
% Create orth from a vector
function [orth] = get_orth (matrix)
orth = zeros(size(matrix, 1), size(matrix, 2));
    for e = 1 : size(matrix, 1)
        len = sqrt(dot(matrix(e, :), matrix(e, :)));
        orth(e, :) = matrix(e, :)/len;
    end
end

% Create Normal - orth(from 1 to 2 env) with n1, n2, incident_vec, refracted_vec
function [Normal] = get_normal (n1, n2, inc_vec, ref_vec)
    inc = get_orth(inc_vec);    refr = get_orth(ref_vec);
    Normal = ( (n1.*inc - n2.*refr) ./ sqrt(dot(n1.*inc - n2.*refr, n1.*inc - n2.*refr, 2)) ); %dim = 2, in rows
end

% Angle by row
function [alpha] = angle(mat1, mat2)
    m1 = get_orth(mat1);    m2 = get_orth(mat2);
    alpha = zeros(size(mat1, 1),1);
    for e = 1 : size(mat1, 1)
        alpha(e, :) = acosd(dot(m1(e, :), m2(e, :), 2));
    end
end

% Distance to plane
% (x, y) - start coord of inc_beam
function [z] = distance_z(x, y, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(1, 3)*h0 - Normal_orth(1, 1)*x - Normal_orth(1, 2)*y)/Normal_orth(1, 3);
end

% Plane visualising
function [i] = visual_plane(Normal, h0)
    x = 0:1:5;
    y = 0:1:5;
    z = ( - Normal(1, 1) * x - Normal(1, 2) * y + Normal(1, 3) * h0 ) / Normal(1, 3);
    i = plot(x, z);  
end