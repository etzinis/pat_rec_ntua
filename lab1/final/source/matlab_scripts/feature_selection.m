%% Pattern Recognition - Lab 1 - Feature Selection
clc; close all; clear all;

%% Read the train_data

% Read train file and reshape it into digit vectors
train_file = fopen('train.txt','r');
formatSpec = '%f';
train_data = fscanf(train_file,formatSpec);
fclose(train_file);

reshaped_train_data = reshape(train_data, 257, []);


%% Calculate Mean and Variance

m = mean(reshaped_train_data(2:257, :), 2);
s = var(reshaped_train_data(2:257, :), 0, 2);


figure;
imagesc(reshape(m, 16, 16)');

figure;
imagesc(reshape(s, 16, 16)');

max_s = max(s);
threshold = 0.0;
selected_features = find(s >= threshold * max_s);

features_file =fopen('selected_features.txt', 'w');
formatSpec = '%d ';
fprintf(features_file, formatSpec, selected_features);
fclose(features_file);
