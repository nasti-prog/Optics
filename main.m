%% Create planes

p0 = [0, 0, 1];

% Parameter of output plane
Z = 1000;

x = 0:1:5;        % равномерное распределение
y = 0:1:5;
[X, Y] = meshgrid(x, y);

u = rand(1, 20);
v = rand(1, 20);
[U, V] = meshgrid(u, v);

% p1
p1 = zeros(50, 3);
for n = 1:36
    for i = 1:20
        for j = 1:20
            p1(n, :) = [U(i,j), V(i,j), Z];
        end
    end
end

% Angles for 1st plane
inc_ang = rand (50, 1);
ref_ang = rand (50, 1);
%inc_ang1 = angle(Normals(1, :), p0);
%ref_ang1 = angle(Normals(1, :), p1_1);

% Normals & orths
Normals = zeros(50, 3);
for i = 1:50
    n1 = 1;
    n2 = 1.48;
    Normals(i, :) = get_normal (n1, n2, p0, p1(i, :), inc_ang(i, :), ref_ang(i, :));
end
%Normals = rand(50, 3);


% Parameter h_0
h_0 = 9 + (10-9)* rand (50, 1);
%h_0 = zeros(50, 1);
%h_0(:, 1) = 10;


%???????
vol = visual_plane(x, y);

visual_plane ([x(4), 0], [y(4), 0]);

% Array_beam of dist to planes
% Column i -- beam i, row i -- plane i
Dist_beam = zeros (50, 36);
for n = 1:36            % Count of beams
    for i = 1:6                     
        for j = 1:6
            for plane = 1:50
                z = distance(plane, i, j, h_0(plane), Normals);
                Dist_beam(plane, n) = z;
            end
        end
    end
end

Dist_min = zeros(1, 36);
for n = 1:36
    Dist_min(1, n) = min (Dist_beam(:, n));
end

% Min distance & index
Min = zeros(11, 11);
Index_plane = zeros(11, 11);

for i = 1:6                      % Count of beams
    for j = 1:6
        x = X(i, j);
        y = Y(i, j);
        min_dist = 1000000;
        index_plane = 1;
        for plane = 1:50
            z = distance(plane, x, y, h_0(plane), Normals);
            if z < min_dist
                min_dist = z;
                index_plane = plane;
            end
        end
        Min(i, j) = min_dist;
        Index_plane(i, j) = index_plane;
    end
end
%% Functions

% Find angle in degrees between vec1 & vec2
function [ang] = angle (vec1, vec2)
    vec_1 = get_orth(vec1);
    vec_2 = get_orth(vec2);
    ang = acosd( dot(vec_1, vec_2) );
end

% Create orth from a vector
function [orth] = get_orth (vector)
    len = sqrt(dot(vector, vector));
    orth = vector/len;
end

% Create Normal - orth(from 1 to 2 env) with n1, n2, incident_vec, refracted_vec, incident_ang, refracted_ang 
% Incident beam - p0 - eд вектор
% Refracted beam - p1
function [Normal] = get_normal (n1, n2, inc_vec, ref_vec, inc_ang, ref_ang )
    Normal = ( (n1*inc_vec - n2*ref_vec) / (n1*cosd(inc_ang) - n2*cosd(ref_ang)) );
end

% Distance to plane
% Ni - components of Normal-vector
% (x, y) - start coord of inc_beam
% h_0 - parameter of the plane
function [z] = distance(index, x, y, h_0, Normals)
    Normal_orth = get_orth(Normals(index, :));
    N1 = Normal_orth(1, 1); 
    N2 = Normal_orth(1, 2);
    N3 = Normal_orth(1, 3);
    z = (N3*h_0 - N1*x - N2*y)/N3;
end

% Evklid distance to plane
function [d] = evkild_distance(index, x_0, y_0, h_0, Normals)
    Normal_orth = get_orth(Normals(index, :));
    N1 = Normal_orth(1, 1);
    N2 = Normal_orth(1, 2);
    N3 = Normal_orth(1, 3);
    len_N = sqrt( dot(Normals(index, :), Normals(index, :)) );
    d = abs(N1*x_0 + N2*y_0 + N3*h_0)/len_N;
end

% Plane visualising
function [z] = visual_plane(x, y)
  z = plot(x, y);  
end