clc; clear all; close all;

%% Pattern Recognition Lab 3

load('lab3_labels.mat');

%% Step 10

good_indices_activation = find(avg_activation ~= 3);
good_indices_valence = find(avg_valence ~= 3);
good_avg_activation = avg_activation(good_indices_activation);
good_avg_valence = avg_valence(good_indices_valence);

good_avg_a = (good_avg_activation > 3) * 1;
good_avg_v = (good_avg_valence > 3) * 1;
zeross = find(good_avg_a == 0);
good_avg_a(zeross) = -1;
good_avg(1) = {good_avg_a};
zeross = find(good_avg_v == 0);
good_avg_v(zeross) = -1;
good_avg(2) = {good_avg_v};

%% Step 11

load('features_new.mat');


good_features6(1) = {normalize_matrix(features6(:,good_indices_activation')')};
good_features7(1) = {normalize_matrix(features7(:,good_indices_activation')')};

good_features6(2) = {normalize_matrix(features6(:,good_indices_valence')')};
good_features7(2) = {normalize_matrix(features7(:,good_indices_valence')')};



N(1) = length(good_indices_activation);
N(2) = length(good_indices_valence);

train_ratio = 0.8;


for a_v = 1:2
    for i = 1:3
        train_test_indices(a_v,i) = {randperm(N(a_v))};
        train_indices(a_v, i) = {train_test_indices{a_v,i}(1:round(N(a_v)*train_ratio))};
        test_indices(a_v, i) = {train_test_indices{a_v,i}((round(N(a_v)*train_ratio)+1):N(a_v))};
        train_labels(a_v,i) = {good_avg{a_v}(train_indices{a_v, i})};
        train_f6(a_v,i) = {good_features6{a_v}(train_indices{a_v, i}, :)};
        train_f7(a_v,i) = {good_features7{a_v}(train_indices{a_v, i}, :)};
        train_f67(a_v,i) = {[train_f6{a_v,i} train_f7{a_v,i}]};

        test_labels(a_v,i) = {good_avg{a_v}(test_indices{a_v, i})};
        test_f6(a_v,i) = {good_features6{a_v}(test_indices{a_v, i}, :)};
        test_f7(a_v,i) = {good_features7{a_v}(test_indices{a_v, i}, :)};
        test_f67(a_v,i) = {[test_f6{a_v,i} test_f7{a_v,i}]};
    end
end

%% Step 12

rate = zeros(5,2,3);
for k = 1:5
    knn = k * 2 - 1;
    for a_v = 1:2
        for i = 1:3
            estimated{k, a_v, i} = call_knn(train_f67{a_v,i}', test_f67{a_v,i}', train_labels{a_v,i}', test_labels{a_v,i}', knn);
            actual{k, a_v, i} = test_labels{a_v,i}';
            rate(k, a_v, i) = length(find(actual{k, a_v,i} == estimated{k, a_v,i})) / length(actual{k, a_v, i});
        end
    end
end

%% Save features
for a_v = 1:2
    for i = 1:3
        names = {'act', 'val'};
        dlmwrite(['features/matlab_extracted_features/train_features6_' names{a_v} '_perm' int2str(i) '.txt'],[train_f6{a_v,i} train_labels{a_v,i}]);
        dlmwrite(['features/matlab_extracted_features/train_features7_' names{a_v} '_perm' int2str(i) '.txt'],[train_f7{a_v,i} train_labels{a_v,i}]);
        dlmwrite(['features/matlab_extracted_features/train_features67_' names{a_v} '_perm' int2str(i) '.txt'],[train_f67{a_v,i} train_labels{a_v,i}]);
        dlmwrite(['features/matlab_extracted_features/test_features6_' names{a_v} '_perm' int2str(i) '.txt'],[test_f6{a_v,i} test_labels{a_v,i}]);
        dlmwrite(['features/matlab_extracted_features/test_features7_' names{a_v} '_perm' int2str(i) '.txt'],[test_f7{a_v,i} test_labels{a_v,i}]);
        dlmwrite(['features/matlab_extracted_features/test_features67_' names{a_v} '_perm' int2str(i) '.txt'],[test_f67{a_v,i} test_labels{a_v,i}]);
        dlmwrite(['features/matlab_extracted_features_5_fold/features6_' names{a_v} '.txt'],[good_features6{a_v} good_avg{a_v}]);
        dlmwrite(['features/matlab_extracted_features_5_fold/features7_' names{a_v} '.txt'],[good_features7{a_v} good_avg{a_v}]);
        dlmwrite(['features/matlab_extracted_features_5_fold/features67_' names{a_v} '.txt'],[good_features6{a_v} good_features7{a_v} good_avg{a_v}]);
    end
end
%% Step 13


for a_v = 1:2
    for i = 1:3
        for j = 1:3
            if j == 1
                train_data = train_f6{a_v,i};
                test_data = test_f6{a_v,i};
            elseif j == 2
                train_data = train_f7{a_v,i};
                test_data = test_f7{a_v,i};
            else
                train_data = train_f67{a_v,i};
                test_data = test_f67{a_v,i};
            end
            train_labs = train_labels{a_v,i};
            test_labs = test_labels{a_v,i};
            good_train = find(train_labs > 0);
            bad_train = find(train_labs < 0);
            
            good_mean = mean(train_data(good_train,:));
            bad_mean = mean(train_data(bad_train,:));
            good_apriori = length(good_train) / size(train_data,1);
            bad_apriori = length(bad_train) / size(train_data,1);
            
            good_bayes_likelihood(a_v,i,j) = {mvnpdf(test_data, good_mean, eye(size(test_data,2))) * good_apriori};
            bad_bayes_likelihood(a_v,i,j) = {mvnpdf(test_data, bad_mean, eye(size(test_data,2))) * bad_apriori};
            bayes_estimated_temp = double(good_bayes_likelihood{a_v,i,j} > bad_bayes_likelihood{a_v,i,j});
            bayes_estimated_temp(bayes_estimated_temp == 0) = -1;
            bayes_estimated(a_v,i,j) = {bayes_estimated_temp};
            
            bayes_rate(a_v,i,j) = length(find(bayes_estimated_temp == test_labs)) / length(test_labs);
        end
    end    
end