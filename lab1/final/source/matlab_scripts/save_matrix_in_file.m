function [ ] = save_matrix_in_file( matrix, file_name )
%SAVE_MATRIX_IN_FILE Summary of this function goes here
%   Detailed explanation goes here
features_file =fopen(file_name, 'w');
formatSpec = '%d %d %d %d %d %d %d %d %d %d\n';
fprintf(features_file, formatSpec, matrix');
fclose(features_file);


end

