%% Distribution of Energy

%Input data.
p0 = [0, 0, 1];
Z = 1000;                                                   % Parameter of output plane

n1 = 1.48;
n2 = 1;

x = 0:0.5:2.5;                                              % equal distribution
y = 0:0.5:2.5;
[X, Y] = meshgrid(x, y);
inc_beams = length(x)*length(y);                            
Aperture = [X(:), Y(:)];                                    % pair of coords by rows

u = 0:2:14;
v = 0:2:14;
[U, V] = meshgrid(u, v);
refr_beams = length(u)*length(v);                            
Display = [U(:), V(:)];

h_0 = 9 + (10-9)* rand(1, refr_beams);                       % Parameter h_0 - count of planes

Energy_inc = (1/inc_beams)*ones(1, inc_beams);                           
Energy_refr = zeros(1, refr_beams);
Energy_req = (1/refr_beams)*ones(1, refr_beams);
Iter = 1000;                                                 
Ismin = false;                                               % alg requires min
alpha = (1E-2)/64;
alpha_max = ((u(length(u)) - u(1))/length(u)) / (max(Energy_req)*length(x));

p1 = [Display(:, 1), Display(:, 2), repmat(Z, refr_beams, 1)];
                          
A = repmat(p0, refr_beams, 1);
Normals = get_normal(n1, n2, A, p1);

ff = get_normal(n1, n2, p0, [6, 0, Z]);                     %Check plane 2
distance_z(0, 0, ff, h_0(1, 2));
distance_z(0.5, 0, ff, h_0(1, 2));

% View of plane
%plane1 = visual_plane(Normals(2, :), h_0(2, 1));

RRMSE = zeros(1, Iter);

for count = 1:Iter
    Energy_refr = zeros(1, refr_beams);                     % row i – plane i, column i – beam i

    Dist_beam = distance_Z(Aperture, Normals, h_0);         % dist to planes for each inc beam

    if Ismin 
        [Dist_need, Index_plane] = min (Dist_beam);
    else 
        [Dist_need, Index_plane] = max (Dist_beam);
    end
    
    for i = 1:inc_beams
        Energy_refr(1, Index_plane(1, i)) = Energy_inc(1, i) + Energy_refr(1, Index_plane(1, i));   
    end
    
    h_0 = get_h_0(h_0, Ismin, alpha, Energy_req, Energy_refr);
    %h_0 = get_h_0(h_0, Ismin, alpha_max, Energy_req, Energy_refr);

    rrmse = ( rmse(Energy_req, Energy_refr) / (sum(Energy_req)/length(Energy_req)) )*100;
    RRMSE(1, count) = rrmse;
    
    subplot(2, 1, 1)
    lumi_map(Energy_refr, count, rrmse)
end

subplot(2, 1, 2)
plot(RRMSE)
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

% Distance to plane
% (x, y) - start coord of inc_beam
function [z] = distance_z(x, y, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(1, 3)*h0 - Normal_orth(1, 1)*x - Normal_orth(1, 2)*y)/Normal_orth(1, 3);
end

function [z] = distance_Z(Coords, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(:, 3).*h0' - Normal_orth(:, 1)* Coords(:, 1)' - Normal_orth(:, 2)*Coords(:, 2)')./Normal_orth(:, 3);
end

% Plane visualising
function [i] = visual_plane(Normal, h0)
    x = 0:1:5;
    y = 0:1:5;
    z = ( - Normal(1, 1) * x - Normal(1, 2) * y + Normal(1, 3) * h0 ) / Normal(1, 3);
    i = plot(x, z);  
end

% Angle by row
function [alpha] = angle(mat1, mat2)
    m1 = get_orth(mat1);    m2 = get_orth(mat2);
    alpha = zeros(size(mat1, 1), size(mat1, 2));
    for e = 1 : size(mat1, 1)
        alpha(e, :) = acosd(dot(m1(e, :), m2(e, :)));
    end
end

% Alpha Optimization
function [alpha_1] = get_alpha(count)
    if count == 1 
       alpha_1 = alpha_0;
    else
        Error = ( rmse(Energy_req, Energy_refr) / (sum(Energy_req)/length(Energy_req)) )*100;
        RRMSE(1, count) = Error; 
        alpha_max = ((u(length(u)) - u(1))/length(u)) / (max(Energy_req)*length(x));
        alpha_min = min(RRMSE);
        alpha_1 = interp2(alpha_max, alpha_min, 'linear');   
    end 
end

function [h_0] = get_h_0(h_0, Ismin, alpha, Matr_req, Matr_i)
    if Ismin
        h_0 = h_0 - alpha * (Matr_req - Matr_i);
    else
        h_0 = h_0 + alpha * (Matr_req - Matr_i);
    end
end

function [] = lumi_map(Matrix, count, Error)
    rows = sqrt(length(Matrix));
    Matr = reshape(Matrix, rows, rows)'; % into square-matr by rows
    imagesc(Matr)
    colorbar
    colormap(gray)                        % color range: jet - rainbow
    title_add = sprintf('Count: %d, Error: %.4f', count, Error);
    title('Display', title_add);
    drawnow
    pause(1e-6)
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