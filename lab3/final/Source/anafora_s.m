close all; 
clear all;
load('/home/thymios/Dropbox/poutana/PatRec/lab3/labels/Labeler2')
load('/home/thymios/Dropbox/poutana/PatRec/lab3/labels/Labeler3')
for i=1:3
    load(['/home/thymios/Dropbox/poutana/PatRec/lab3/labels/Labeler' mat2str(i) '.mat']);
    for j=1:412
        activation(j,i) = labelList(j).activation;
        valence(j,i) = labelList(j).valence;
    end
end

%% Agreement

[dif12a, hist12a] = find_mean_agreement(activation, 1,2);
[dif12v, hist12v] = find_mean_agreement(valence, 1,2);

[dif23a, hist23a] = find_mean_agreement(activation, 2,3);
[dif23v, hist23v] = find_mean_agreement(valence, 2,3);

[dif31a, hist31a] = find_mean_agreement(activation, 3,1);
[dif31v, hist31v] = find_mean_agreement(valence, 3,1);

%% Disagreement computation
[Disagreement_Valence, a_Valence] = Compute_Differencial_Metric_Ordinal(valence);
[Disagreement_Activation, a_Activation] = Compute_Differencial_Metric_Ordinal(activation);

%% Step 5 Average Values for Valence and Activation
avg_valence = sum(valence,2)/3;
avg_activation = sum(valence,2)/3;

% Compute and demonstrate the respective histogram
labels = zeros(5);
for i = 1:size(valence,1)  
    for j = 1:size(valence,2)
            y = activation(i,j);
            x = valence(i,j);
            labels(y,x) = labels(y,x) + 1;
    end
end

figure()
image(labels(:,:));
title(['Co-occurence Matrix Final Ratings']);
xlabel('Valence');
ylabel('Activation');
colorbar
saveas(gcf, ['/home/thymios/Dropbox/poutana/PatRec/lab3/images/Co-occurence Matrix Final Ratings.png'])


