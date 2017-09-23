function [ Dordinal, acoef ] = Compute_Differencial_Metric_Ordinal( matrix )

%% Disagreement computation
Cooccurence = zeros(5);
for i = 1:size(matrix,1)
    allperms = combnk(matrix(i,:), 2);
    for j=1:size(allperms,1)
        Cooccurence(allperms(j,1),allperms(j,2)) = Cooccurence(allperms(j,1),allperms(j,2)) + 1;
        Cooccurence(allperms(j,2),allperms(j,1)) = Cooccurence(allperms(j,2),allperms(j,1)) + 1;
    end
    
end 

freqsums = sum(Cooccurence);
Dordinal = zeros(5);

% compute for ordinal data the different metric
for i=1:size(Cooccurence,1)
    for j=1:size(Cooccurence,2)
        if (j>= i)
            Dordinal(i,j) = ( sum(freqsums(i:j)) - (freqsums(i) + freqsums(j))/2 ) ^ 2 ;
        end
    end
end

maxim = freqsums(1);
minima = freqsums(size(freqsums,2));
summa = sum (freqsums);
regconstant = (summa - (maxim + minima)/2) ^ 2;

% maybe we need to regulate the values of the matrix
Dordinal = Dordinal / regconstant;

% Compute a coefficient
Do = 0;
De = 0;
for i=1:size(Cooccurence,1)
    for j=1:size(Cooccurence,2)
        if (j>= i)
            De = De + freqsums(i)*freqsums(j)*Dordinal(i,j);
            Do = Do + Cooccurence(i,j)*Dordinal(i,j);
        end
    end
end
acoef = 1 - (summa - 1) * (Do / De);

end


