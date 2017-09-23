function [ estimated ] = find_knn( distances, k, opt)
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
%     if(opt == 1)
%         majority_count = length(find(top_k(i,:) == maj)); 
%         if(majority_count < 0.3 * size_2)
%             estimated(i) = top_k(i,1);
%         else
%             estimated(i) = maj;
%         end
%     else
%         estimated(i) = maj;
%     end
    estimated(i) = maj;
end



end

