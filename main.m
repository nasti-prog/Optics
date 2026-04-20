%% Create planes

p0 = [0, 0, 1];

x = [1, 2];
y = [2, 3];
[X, Y] = meshgrid(x, y);

u = [3, 5];
v = [4, 6];
[U, V] = meshgrid(u, v);

% Parameter h_0
h_0 = rand(4, 1);

% Normals & orths
Normals = rand(4, 3);

N1 = get_orth(Normals(1, :));
disp (N1);
N2 = get_orth(Normals(2, :));
N3 = get_orth(Normals(3, :));
N4 = get_orth(Normals(4, :));

% Parameter of output plane
Z = 10;

% p1
p1_1 = [U(1,1), V(1,1), Z];
p1_2 = [U(2,1), V(2,1), Z];
p1_3 = [U(1,2), V(1,2), Z];
p1_4 = [U(2,2), V(2,2), Z];

% Angles for 1st plane
inc_ang1 = angle(N1, p0);
ref_ang1 = angle(N1, p1_1);

% To create Plane should be used h_0 and Normal  with the same index
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