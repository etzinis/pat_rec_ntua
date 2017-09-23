%% Pattern Recognition - Lab 1 - Feature Selection
clc; close all; clear all;

%% Read the train_data

% Read train file and reshape it into digit vectors
train_file = fopen('train.txt','r');
formatSpec = '%f';
train_data = fscanf(train_file,formatSpec);
fclose(train_file);

reshaped_train_data = reshape(train_data, 257, []);

images_array = reshape(reshaped_train_data(2:257,:), 16, 16, []);

figure;
imagesc(images_array(:,:,131));

figure;
imagesc(imgaussfilt(images_array(:,:,131)));

%%

h = fspecial('laplacian');

new_images = zeros(256, size(reshaped_train_data,2));
for i = 1:size(images_array,3)
    %temp = imfilter(images_array(:,:,i),h,'replicate');
    temp = imgaussfilt(images_array(:,:,i));
    new_images(:,i) = reshape(temp, 256, []);
end

out_file = fopen('train_log.txt','w');
formatSpec = '%f ';
for i =1:size(new_images,2) 
    fprintf(out_file,formatSpec, reshaped_train_data(1,i));
    fprintf(out_file,formatSpec, new_images(1:255,i));
    fprintf(out_file,'%f\n', new_images(256,i)); 
end
    
fclose(out_file);

