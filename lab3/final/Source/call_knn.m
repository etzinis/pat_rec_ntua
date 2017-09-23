function [ estimated_knn ] = call_knn( train_data, test_data, train_labels, test_labels, k )
    
    len_of_train = size(train_data,2);

    for i=1:size(test_data,2)
        curr_test = test_data(:,i);
        diff = (repmat(curr_test, [1 len_of_train]) - train_data).^2;
        distances = sqrt(sum(diff,1));
        [~,distance_indexes(i,:)] = sort(distances,'ascend');
        conf_distance(i) = distances(distance_indexes(i,1));
    end

    knn_result = find_knn(distance_indexes, k);
    estimated_knn = train_labels(1,knn_result);
    
end

