%% Pattern Recognition - Lab 1
clc; close all; clear all;

% Used for VPA
digits(3);

%% Read Train and Test File

% Read train file and reshape it into digit vectors
train_file = fopen('train.txt','r');
formatSpec = '%f';
train_data = fscanf(train_file,formatSpec);
fclose(train_file);

reshaped_train_data = reshape(train_data, 257, []);

% Read tets file and reshape it into digit vectors
test_file = fopen('test.txt','r');
formatSpec = '%f';
test_data = fscanf(test_file,formatSpec);
fclose(test_file);

reshaped_test_data = reshape(test_data, 257, []);


% Print Digit 131
figure;
imagesc(reshape(reshaped_train_data(2:257,131), 16, 16)');


%% Find mean and var of each class features

m = [];
s = [];
for i = 0:9
    [m_t, s_t] = find_mean_var(reshaped_train_data, i);
    m(:,i+1) = m_t(:);
    s(:,i+1) = s_t(:);
end    

% Show variance of 0
figure;
imagesc(reshape(m(:,1), 16, 16)');
figure;
imagesc(reshape(s(:,1)', 16, 16)');


for i = 1:10
    figure;
    imagesc(reshape(m(:,i), 16, 16)');
end


mean0 = reshape(m(:,1), 16, 16);
var0 = reshape(s(:,1), 16, 16);

%latex(vpa(sym(mean0), 3))
%latex(vpa(sym(var0), 3))

display(mean0(10,10));
display(var0(10,10));


%% Classify all the test digits

actual = reshaped_test_data(1,:);
estimated = [];
for i = 1:size(reshaped_test_data, 2)
    estimated(i) = euclidean_classifier(reshaped_test_data(2:257, i), m);
end

% Show 101 digit actual and estimated label
display(actual(101));
display(estimated(101));


%% Calculate Total Recall

correct = 0;
for i = 1:length(actual)
    if actual(i) == estimated(i)
        correct = correct + 1;
    end
end

total_recall = correct / length(actual);
display(total_recall);

