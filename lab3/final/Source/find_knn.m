function [ estimated ] = find_knn( distances, k)
%FIND_KNN Summary of this function goes here
%   Detailed explanation goes here
top_k = distances(:,1:k);

size_2 = size(top_k, 2);
estimated = zeros(size(top_k, 1),1);
for i=1:size(top_k, 1)
    maj = top_k(i,1);
    majcnt = 1;
    for j = 2:size_2
        curr = top_k(i,j);
        if( curr == maj)
            majcnt = majcnt + 1
        else
            if(majcnt == 1)
                maj = curr;
            else
                majcnt = majcnt - 1;
            end
        end
    end

    estimated(i) = maj;
end

end

