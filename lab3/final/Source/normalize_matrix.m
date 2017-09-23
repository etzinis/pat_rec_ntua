function [ normalized ] = normalize_matrix( data )
%NORMALIZE_VECTOR Summary of this function goes here
%   Detailed explanation goes here
    normalized = (data - repmat(min(data,[],1), size(data,1), 1)) ./ (repmat(max(data,[],1), size(data,1), 1) - repmat(min(data,[],1), size(data,1), 1) );
end

