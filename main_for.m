%% Distribution of Energy
p0 = [0, 0, 1];                                             %Input data
Z = 1000;                                                   
n1 = 1.48;
n2 = 1;
Iter = 1000;                                                 
Ismin = false;                                              

x = 0:0.5:7;                                              % Aperture & Display
y = 0:0.5:7;
[X, Y] = meshgrid(x, y);
inc_beams = length(x)*length(y)                          
Aperture = [X(:), Y(:)];                                   
u = 0:2:14;
v = 0:2:14;
[U, V] = meshgrid(u, v);
refr_beams = length(u)*length(v)                            
Display = [U(:), V(:)];

Energy_inc = (1/inc_beams)*ones(1, inc_beams);                           
Energy_req = (1/refr_beams)*ones(1, refr_beams);
alpha_max = ((u(length(u)) - u(1))/length(u)) / (max(Energy_req)*length(x));

p1 = [Display(:, 1), Display(:, 2), repmat(Z, refr_beams, 1)];

A = repmat(p0, refr_beams, 1);
Normals = get_normal(n1, n2, A, p1);

h_0 = 9 + (10-9)* rand(1, refr_beams);
alpha = (1E-2);
Error = zeros(1, Iter);
[h_0, alpha] = update(Aperture, Normals, h_0, Energy_inc, Energy_req, Ismin, alpha, alpha_max, Iter);
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
    alpha = zeros(size(mat1, 1), size(mat1, 2));
    for e = 1 : size(mat1, 1)
        alpha(e, :) = acosd(dot(m1(e, :), m2(e, :)));
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
%% Fresnel

% Amplitude
function [t] = t(n1, n2, oi, ot, type)
    if (type == 'p')
        t = (2*n1*cosd(oi)/n2*cosd(oi) + n1*cosd(ot)); %p
    else
        t = (2*n1*cosd(oi)/n1*cosd(oi) + n2*cosd(ot)); %s
    end
end

% Energy
function [T] = T(n1, n2, oi, ot, type)
    if type == 'p'
        T = (n2*cosd(ot)/n1*cosd(oi))* abs( t(n1, n2, oi, ot, "p") )^2; %p
    elseif type == 's'
        T = (n2*cosd(ot)/n1*cosd(oi))* abs( t(n1, n2, oi, ot, "s") )^2; %s
    else
        T = (n2*cosd(ot)/n1*cosd(oi))* 0.5 * (abs( t(n1, n2, oi, ot, "s") )^2 + abs( t(n1, n2, oi, ot, "p") )^2); %unpolarized
    end
end