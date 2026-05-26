%% Distribution of Energy

%Input data.
p0 = [0, 0, 1];
Z = 1000;                                                   % Parameter of output plane

n1 = 1.48;
n2 = 1;

x = 0:0.5:2.5;                                              % равномерное распределение
y = 0:0.5:2.5;
[X, Y] = meshgrid(x, y);
inc_beams = length(x)*length(y);                            %count of incident beams
Aperture = [X(:), Y(:)];                                    % pair of coords by rows

u = 0:1:7;
v = 0:1:7;
[U, V] = meshgrid(u, v);
refr_beams = length(u)*length(v);                            % count of refracted beams
Display = [U(:), V(:)];

h_0 = 9 + (10-9)* rand(refr_beams, 1);                       % Parameter h_0 - count of planes

Iter = 1000;                                                 % Count of iterations
Ismin = false;                                               % alg requires min
alpha = 1;                                                   % trained num;
Energy_inc = 2*ones(1, inc_beams);                           % Energy
Energy_refr = 2*ones(1, refr_beams);
Energy_req = 6*ones(1, refr_beams);

j = 1:refr_beams;
p1 = zeros(refr_beams, 3);                                  % p1         
p1(j, :) = [Display(j, 1), Display(j, 2), repmat(Z, refr_beams, 1)];

Normals = zeros(refr_beams, 3);                             % Normals & orths
A = repmat(p0, refr_beams, 1);
Normals(j, :) = get_normal(n1, n2, A(j, :), p1(j, :));

%Check plane 2
ff = get_normal(n1, n2, p0, [6, 0, Z]);
distance_z(0, 0, ff, h_0(2, 1));
distance_z(0.5, 0, ff, h_0(2, 1));

% View of plane
%plane1 = visual_plane(Normals(2, :), h_0(2, 1));

Dist_beam = zeros (refr_beams, inc_beams);                                                      % row i – plane i, column i – beam i
count = 0;

for count = 1:2      

    for i = 1:inc_beams
        for j = 1:refr_beams
            Dist_beam(j, i) = distance_Z(Aperture(i, :), Normals(j, :), h_0(j));         % dist to planes for each inc beam
        end
    end

    Dist_need = zeros(1, inc_beams);
    if Ismin 
        [Dist_need(2, :), Dist_need(1, :)] = min (Dist_beam);
    else 
        [Dist_need(2, :), Dist_need(1, :)] = max (Dist_beam);
    end

    Plane = Dist_need(1, i);
    Energy_refr(1, Plane) = Energy_refr(1, Plane) + Energy_inc(1, i);

    h_0 = h_0 + alpha * (Energy_req - Energy_refr);
end
deltaE = Energy_req - Energy_refr;
count;
%% Functions

% Create orth from a vector
function [orth] = get_orth (matrix)
orth = zeros(size(matrix, 1), size(matrix, 2));
    for e = 1 : size(matrix, 1)
        len = sqrt(dot(matrix(e, :), matrix(e, :)));
        orth(e, :) = matrix(e, :)/len;
    end
end

% Create Normal - orth(from 1 to 2 env) with n1, n2, incident_vec, refracted_vec, incident_ang, refracted_ang
function [Normal] = get_normal (n1, n2, inc_vec, ref_vec)
    inc = get_orth(inc_vec);
    refr = get_orth(ref_vec);
    Normal = ( (n1.*inc - n2.*refr) ./ sqrt(dot(n1.*inc - n2.*refr, n1.*inc - n2.*refr, 2)) );
end

% Distance to plane
% (x, y) - start coord of inc_beam
% h_0 - parameter of the plane
function [z] = distance_z(x, y, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(1, 3)*h0 - Normal_orth(1, 1)*x - Normal_orth(1, 2)*y)/Normal_orth(1, 3);
end

function [z] = distance_Z(Coords, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(1, 3).*h0 - Normal_orth(1, 1).* Coords(1, 1) - Normal_orth(1, 2).*Coords(1, 2))./Normal_orth(1, 3);
end

% Plane visualising
function [i] = visual_plane(Normal, h0)
    x = 0:1:5;
    y = 0:1:5;
    z = ( - Normal(1, 1) * x - Normal(1, 2) * y + Normal(1, 3) * h0 ) / Normal(1, 3);
    i = plot(x, z);  
end