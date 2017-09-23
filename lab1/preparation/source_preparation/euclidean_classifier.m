function [ label ] = euclidean_classifier( vector, mean_values )
%EUCLIDEAN_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

dists = [];
for i = 0:9
    dists(i+1) = norm(vector - mean_values(:,i+1), 2);
end

[~, index] = min(dists);

label = index -1;

end

