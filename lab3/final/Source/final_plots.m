%clear all;
%close all;

%data=[0.710 0.699 0.685 ; 0.788 0.808 0.802 ; 0.786 0.799 0.783 ; 0.802 0.830 0.805];
%name = 'Final Accuracy Results';

features={'Mir Emotion Features', 'MFCCs', 'Combined', 'Combined and Wrapper'};
figure();
bar(data);
legend('Random Forest','SVM', 'MLP', 'Location', 'southeast')
grid on
set(gca, 'YTick', 0.0:0.05:1);
set(gca, 'Xtick', 1:size(data,1), 'XtickLabel', features)
title(name);
saveas(gcf, ['images/Final_' name '.png'])
    