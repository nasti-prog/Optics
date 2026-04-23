%% Create planes

p0 = [0, 0, 1];

% Parameter of output plane
Z = 1000;

x = 0:0.5:5;        % равномерное распределение
y = 0:0.5:5;
[X, Y] = meshgrid(x, y);

u = rand(1, 10);
v = rand(1, 10);
[U, V] = meshgrid(u, v);

% p1
p1_1 = [U(1,1), V(1,1), Z];
p1_2 = [U(2,1), V(2,1), Z];
p1_3 = [U(1,2), V(1,2), Z];
p1_4 = [U(2,2), V(2,2), Z];

% Normals & orths
Normals = rand(50, 3);
N1 = get_orth(Normals(1, :));

% Angles for 1st plane
inc_ang1 = angle(N1, p0);
ref_ang1 = angle(N1, p1_1);

% Parameter h_0
h_0 = zeros(50, 1);
h_0(:, 1) = 10;

% Min distance & index
Min = zeros(11, 11);
Index_plane = zeros(11, 11);

for i = 1:11                      % Count of beams
    for j = 1:11
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
    ang = acosd( dot(vec_1, vec_2) / (sqrt(dot(vec_1, vec_1))*sqrt(dot(vec_2, vec_2))) );
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
    len = sqrt(dot(Normal_orth, Normal_orth));
    disp(len);
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