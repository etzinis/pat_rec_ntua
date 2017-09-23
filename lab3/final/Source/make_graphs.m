close all; clear all; clc;

%% Global Constans
result_dir = 'results/';

%% Knn
knn_res_dir = 'knn_averages/';

%% Activation 
fileID = fopen([result_dir knn_res_dir 'knn_act-matlab'],'r');
data = fscanf(fileID,'%f,%f\n');
fclose(fileID);

graph_knn(data, 'Activation');

%% Valence
fileID = fopen([result_dir knn_res_dir 'knn_val-matlab'],'r');
data = fscanf(fileID,'%f,%f\n');
fclose(fileID);

graph_knn(data, 'Valence');

%% Bayes
knn_res_dir = 'naive_bayes_averages/';

%% Activation 
fileID = fopen([result_dir knn_res_dir 'naive_bayes_act-matlab'],'r');
data = fscanf(fileID,'%f,%f\n');
fclose(fileID);

graph_bayes(data, 'Activation');

%% Valence
fileID = fopen([result_dir knn_res_dir 'naive_bayes_val-matlab'],'r');
data = fscanf(fileID,'%f,%f\n');
fclose(fileID);

graph_bayes(data, 'Valence');
