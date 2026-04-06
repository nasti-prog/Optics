function[angle_v] = angle_vectors(vec1, vec2)
angle_v = acosd( dot(vec1, vec2)/ (sqrt(dot(vec1, vec1))*sqrt(dot(vec2, vec2))) );
end