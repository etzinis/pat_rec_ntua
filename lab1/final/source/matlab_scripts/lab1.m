%% Pattern Recognition - Lab 1
clc; close all; clear all;

% Used for VPA
digits(3);

%% Read Train and Test File

% Read train file and reshape it into digit vectors
train_file = fopen('input/smoothed2/train_smoothed2.txt','r');
formatSpec = '%f';
train_data = fscanf(train_file,formatSpec);
fclose(train_file);

reshaped_train_data = reshape(train_data, 257, []);

% Read tets file and reshape it into digit vectors
test_file = fopen('input/smoothed2/test_smoothed2.txt','r');
formatSpec = '%f';
test_data = fscanf(test_file,formatSpec);
fclose(test_file);

reshaped_test_data = reshape(test_data, 257, []);


% Print Digit 131
% figure;
% imagesc(reshape(reshaped_train_data(2:257,131), 16, 16)');


%% Find mean and var of each class features

m = [];
s = [];
for i = 0:9
    [m_t, s_t] = find_mean_var(reshaped_train_data, i);
    m(:,i+1) = m_t(:);
    s(:,i+1) = s_t(:);
end    

% Show variance of 0
% figure;
% imagesc(reshape(m(:,1), 16, 16)');
% figure;
% imagesc(reshape(s(:,1)', 16, 16)');

% 
% for i = 1:10
%     figure;
%     imagesc(reshape(m(:,i), 16, 16)');
% end


mean0 = reshape(m(:,1), 16, 16);
var0 = reshape(s(:,1), 16, 16);

%latex(vpa(sym(mean0), 3))
%latex(vpa(sym(var0), 3))

% display(mean0(10,10));
% display(var0(10,10));


%% Classify all the test digits

actual = reshaped_test_data(1,:);
estimated = [];
for i = 1:size(reshaped_test_data, 2)
    estimated(i) = euclidean_classifier(reshaped_test_data(2:257, i), m);
end

% Show 101 digit actual and estimated label
% display(actual(101));
% display(estimated(101));

[total_recall, class_matr] = total_rec(actual, estimated);
display(total_recall);
display(class_matr);
save_matrix_in_file(class_matr, 'confusion_matrices/matrix_mean.txt')


%% Calculate A-Priori Probabilities

total_appearances = reshaped_train_data(1,:);
digit_appearance = zeros(10,1);
for i = 1:10
    digit_appearance(i) = sum(total_appearances == (i-1));
end

a_priori = digit_appearance/length(total_appearances);


%% Bayesian Classifier


for j = 1:10

    % TODO: Loop the following
    sigma(:,:,j) = diag(s(:,j));
 
    % Fix non positive definite sigma 
    [V, D] = eig(sigma(:,:,j));
    diagony = diag(D);
    non_pos_eig = find(diagony <= 0);

    epsy = 0.0;
    new_sigma  = sigma(:,:,j);
    for i = 1:length(non_pos_eig)
        ind = non_pos_eig(i);
        %epsy = eps(diagony(ind));
        %new_sigma = new_sigma + V(:,ind)*V(:,ind)'*(epsy-diagony(ind)); 
        new_sigma = new_sigma + V(:,ind)*V(:,ind)'*(1-diagony(ind)); 
    end

    likelihood(:,j) = mvnpdf(reshaped_test_data(2:257, :)', m(:,j)', new_sigma) * a_priori(j);
    %likelihood(:,j) = mvnpdf(reshaped_test_data(12:21, :)', m(11:20,j)', new_sigma(11:20,11:20));

end

[max_v, max_i] = max(likelihood, [], 2);

[total_recall_bayes, class_matr_bayes] = total_rec(actual, max_i-1);
display(total_recall_bayes);
save_matrix_in_file(class_matr_bayes, 'confusion_matrices/matrix_bayes.txt')


%% Bayes without Variance


for j=1:10
    without_likelihood(:,j) = mvnpdf(reshaped_test_data(2:257, :)', m(:,j)', eye(256)) * a_priori(j);
end

[without_max_v, without_max_i] = max(without_likelihood, [], 2);

[total_recall_bayes_without, class_matr_bayes_without] = total_rec(actual, without_max_i-1);
display(total_recall_bayes_without);
save_matrix_in_file(class_matr_bayes_without, 'confusion_matrices/matrix_bayes_without.txt')

%% 1NN Test-100 Train-1000

thousand_train = reshaped_train_data(2:257, 1:1000);
for i=1:100
    curr_test = reshaped_test_data(2:257, i);
    for j =1:1000
        distance_partial(j) = norm(curr_test - thousand_train(:,j), 2); 
    end
    [~,distance_indexes_partial(i,:)] = sort(distance_partial,'ascend');
end

estimated_1nn_partial = reshaped_train_data(1, distance_indexes_partial(:,1));
[total_recall_1nn_partial, class_matr_1nn_partial] = total_rec(actual(1:100), estimated_1nn_partial);
display(total_recall_1nn_partial);

%% 1NN All-Test All-Train
distance_method = 'euclidean';
len_of_train = size(reshaped_train_data,2);

for i=1:size(reshaped_test_data,2)
    curr_test = reshaped_test_data(2:257, i);
%     for j =1:size(reshaped_train_data,2)
%         distance(j) = norm(curr_test - reshaped_train_data(2:257,j), 2); 
%     end
    if(strcmp(distance_method,'euclidean'))
        diff = (repmat(curr_test, [1 len_of_train]) - reshaped_train_data(2:257,:)).^2;
        distances = sqrt(sum(diff,1));
        [~,distance_indexes(i,:)] = sort(distances,'ascend');
        conf_distance(i) = distances(distance_indexes(i,1));
    else
        dot_pr = sum(repmat(curr_test, [1 len_of_train]).*reshaped_train_data(2:257,:),1); 
        norm1 = sqrt(sum(curr_test.^2));
        norm2 = sqrt(sum(reshaped_train_data(2:257,:).^2,1));
        distances = dot_pr./(norm1*norm2);
        [~,distance_indexes(i,:)] = sort(distances,'descend');
    end
        
    
end

%%

estimated_1nn = reshaped_train_data(1, distance_indexes(:,1));
confidence_1nn_t = exp(1).^(-conf_distance);
confidence_1nn = confidence_1nn_t./max(confidence_1nn_t); 
[total_recall_1nn, class_matr_1nn] = total_rec(actual, estimated_1nn);
save_matrix_in_file(class_matr_1nn, 'confusion_matrices/matrix_1nn.txt')
display(total_recall_1nn);

out_1nn =fopen('1nn_results.txt', 'w');
formatSpec = '%d\n';
fprintf(out_1nn, formatSpec, estimated_1nn);
fclose(out_1nn);



%% KNN All

knn_result = find_knn(distance_indexes, 3, 0);
estimated_knn = reshaped_train_data(1,knn_result);
[total_recall_knn, class_matr_knn] = total_rec(actual, estimated_knn);
display(total_recall_knn);
save_matrix_in_file(class_matr_knn, 'confusion_matrices/matrix_knn.txt')

