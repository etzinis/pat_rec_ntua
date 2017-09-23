function [ ] = graph_bayes( data , name)
%GRAPH_KNN Summary of this function goes here
%   Detailed explanation goes here
    
    % 1st dim: Accuracy - F_measure
    % 2nd dim: Pca-conf(100, 10, 15, 167, 25, 50, 5, res67, res6, res7)
    ready_to_graph = reshape(data, 2, 10);

    pca_rearrange_vector = [9, 10, 8, 7, 2, 3, 5, 6, 1, 4];

    ready_to_graph = ready_to_graph(:,pca_rearrange_vector);
    xlabels = {'mir', 'mfccs', 'all', 'pca5', 'pca10', 'pca15', 'pca25', 'pca50', 'pca100', 'pca167'};
    leg_labels = {'1nn', '3nn', '5nn', '7nn', '9nn', '11nn'};

    % Accuracy
    figure();
    plot(squeeze(ready_to_graph(1,:)));
    set(gca, 'Xtick', 1:10, 'XtickLabel', xlabels)
    title(name);
    ylabel('Accuracy');
    saveas(gcf, ['images/bayes_' name '_accuracy.png'])
    
    % F-measure
    figure();
    plot(squeeze(ready_to_graph(2,:)));
    set(gca, 'Xtick', 1:10, 'XtickLabel', xlabels)
    title(name);
    ylabel('F-Measure');
    saveas(gcf, ['images/bayes_' name '_f-measure.png'])

end

