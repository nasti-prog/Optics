function [ort] = ort_vector(vector)
len = sqrt(dot(vector, vector));
ort = vector/len;
end