function [ total_recall, class_matrix ] = total_rec( actual, estimated )
%TOTAL_REC Summary of this function goes here
%   Detailed explanation goes here
correct = 0;
for i = 1:length(actual)
    if actual(i) == estimated(i)
        correct = correct + 1;
    end
end
total_recall = correct / length(actual);

class_matrix = zeros(10,10);
for i = 1:length(actual)
    class_matrix(actual(i)+1, estimated(i)+1) = class_matrix(actual(i)+1, estimated(i)+1) + 1;
end

end

