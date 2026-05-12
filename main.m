%% Distribution of Energy

%Input data
p0 = [0, 0, 1];
Z = 1000;                                         % Parameter of output plane

n1 = 1.48;
n2 = 1;

x = 0:0.5:2.5;                                      % равномерное распределение
y = 0:0.5:2.5;
[X, Y] = meshgrid(x, y);
inc_beams = length(x)*length(y)                 % count of incident beams

u = 0:1:7;
v = 0:1:7;
[U, V] = meshgrid(u, v);
refr_beams = length(u)*length(v)                % count of refracted beams

h_0 = 9 + (10-9)* rand(50, 1);                 % Parameter h_0 - count of planes
%Planes = size(h_0, 1);

Energy = 2*ones(inc_beams, 1);                  % Energy

p1 = zeros(refr_beams, 3);                      % p1
for i = 0 : length(u)-1
    for j = 0 : length(v)-1
        p1(i * length(v) + j + 1, :) = [U(i+1, j+1), V(i+1, j+1), Z];
    end
end

% Normals & orths
Normals = zeros(50, 3);
for i = 1:50              
    Normals(i, :) = get_normal (n1, n2, p0, p1(i, :));
end

%Check plane 1
ff = get_normal(n1, n2, p0, [12, 0, Z]);
distance_z(0, 0, ff, h_0(1, 1));
distance_z(4, 0, ff, h_0(1, 1));

%Check plane 2
ff = get_normal(n1, n2, p0, [6, 0, Z]);
distance_z(0, 0, ff, h_0(2, 1));
distance_z(0.5, 0, ff, h_0(2, 1));

% View of plane
%plane1 = visual_plane(Normals(2, :), h_0(2, 1));


% Array_beam of dist to planes
% Column i – beam i, row i – plane i

Dist_beams = zeros (50, 1);
Coords = [X(:), Y(:)];      % pair of coords by rows
for i = 1:inc_beams
    for plane = 1:50
        z = distance_Z(Coords(i, :), Normals(plane, :), h_0(plane, :));
        Dist_beams(plane, i) = z;
    end
end



Dist_beam = zeros (50, inc_beams);
% Distance & min, max dist to planes for each incident beam
for cord_x = 0 : length(x)-1
    for cord_y = 0 : length(y)-1
        for plane = 1:50
            z = distance_z(cord_x, cord_y, Normals(plane, :), h_0(plane, :));
            Dist_beam(plane, cord_x*length(y) + cord_y + 1) = z;
        end
    end 
end

Dist_min = zeros(1, inc_beams);
for n = 1:inc_beams
    Dist_min(1, n) = min (Dist_beam(:, n));
end

Dist_max = zeros(1, inc_beams);
for n = 1:inc_beams
    Dist_max(1, n) = max (Dist_beam(:, n));
end

%Zak = (Normals(1, 3)*h_0(1, 1) - Normals(1, 1)*X - Normals(1, 2)*Y)/Normals(1, 3)
%Dist_mini = zeros(1, inc_beams);
%for planes = 1:50
%    %Dist_beam = distance_Z(Matrix);    %matrix function
%    Dist_mini(1, plane) = min(Matrix);
%end
%% Functions

% Create orth from a vector
function [orth] = get_orth (vector)
    len = sqrt(dot(vector, vector));
    orth = vector/len;
end

% Create Normal - orth(from 1 to 2 env) with n1, n2, incident_vec, refracted_vec, incident_ang, refracted_ang 
% Incident beam - p0 - eд вектор
% Refracted beam - p1
function [Normal] = get_normal (n1, n2, inc_vec, ref_vec)
    inc = get_orth(inc_vec);
    refr = get_orth(ref_vec);
    Normal = ( (n1*inc - n2*refr) / sqrt(dot(n1*inc - n2*refr, n1*inc - n2*refr)) );
end

% Distance to plane
% Ni - components of Normal-vector
% (x, y) - start coord of inc_beam
% h_0 - parameter of the plane
function [z] = distance_z(x, y, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(1, 3)*h0 - Normal_orth(1, 1)*x - Normal_orth(1, 2)*y)/Normal_orth(1, 3);
end

function [z] = distance_Z(Coords, Normal, h0)
    Normal_orth = get_orth(Normal);
    z = (Normal_orth(1, 3)*h0 - Normal_orth(1, 1)*Coords(1, 1) - Normal_orth(1, 2)*Coords(1, 2))/Normal_orth(1, 3);
end

% Plane visualising
function [i] = visual_plane(Normal, h0)
    x = 0:1:5;
    y = 0:1:5;
    z = ( - Normal(1, 1) * x - Normal(1, 2) * y + Normal(1, 3) * h0 ) / Normal(1, 3);
    i = plot(x, z);  
end

