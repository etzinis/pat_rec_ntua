function [ output, histo_data ] = find_mean_agreement( arr, i1, i2 )
%FIND_MEAN_AGREEMENT Summary of this function goes here
%   Detailed explanation goes here
histo_data = abs(arr(:,i1) - arr(:,i2));
output = 1 - mean(histo_data/4);

end

