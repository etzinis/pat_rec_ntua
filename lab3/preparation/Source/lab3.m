clc; clear all; close all;

%% Pattern Recognition Lab 3

%% Read the audio files
data_dir = 'data_path_here';

number_of_files = 412;
newFs = 22050;
data = cell(number_of_files,1);
for i = 1:number_of_files
    [y, Fs] = audioread([data_dir 'file' mat2str(i) '.wav']);   
    mono_y = y(:,1) + y(:,2) /2;
    bit_y = round(2^7*mono_y)/2^7;
    resampled_y = resample(bit_y, newFs, Fs);
    data{i} = resampled_y; 
end


%% Statistics for tags

tag_data_dir = 'rating_path_here';
number_of_files = 412;
n_of_labelers = 3;
labels = zeros(5,5,n_of_labelers);
for i = 1:n_of_labelers
    load([tag_data_dir 'Labeler' mat2str(i) '.mat']);
    valence(:,i) = [labelList.valence]';
    activation(:,i) = [labelList.activation]';
    for j = 1:number_of_files
        y = activation(j,i);
        x = valence(j,i);
        labels(y,x,i) = labels(y,x,i) + 1;
    end
    figure()
    image(labels(:,:,i));
    title(['Co-occurence Matrix Rater ' mat2str(i)]);
    xlabel('Valence');
    ylabel('Activation');
    colorbar
    saveas(gcf, ['Co-occurence Matrix Rater ' mat2str(i) '.png'])
    statistics(1,1,i) = mean(activation(:,i));
    statistics(1,2,i) = var(activation(:,i));
    statistics(2,1,i) = mean(valence(:,i));
    statistics(2,2,i) = var(valence(:,i));
    
end

%% Agreement

[dif12a, hist12a] = find_mean_agreement(activation, 1,2);
[dif12v, hist12v] = find_mean_agreement(valence, 1,2);

[dif23a, hist23a] = find_mean_agreement(activation, 2,3);
[dif23v, hist23v] = find_mean_agreement(valence, 2,3);

[dif31a, hist31a] = find_mean_agreement(activation, 3,1);
[dif31v, hist31v] = find_mean_agreement(valence, 3,1);

figure;
subplot(3,2,1);
histogram(hist12a);
title('Activation Diff Labeler 1-2');
xlabel('Value');
ylabel('Occurences');
subplot(3,2,2);
histogram(hist12v);
title('Valence Diff Labeler 1-2');
xlabel('Value');
ylabel('Occurences');
subplot(3,2,3);
histogram(hist23a);
title('Activation Diff Labeler 2-3');
xlabel('Value');
ylabel('Occurences');
subplot(3,2,4);
histogram(hist23v);
title('Valence Diff Labeler 2-3');
xlabel('Value');
ylabel('Occurences');
subplot(3,2,5);
histogram(hist31a);
title('Activation Diff Labeler 3-1');
xlabel('Value');
ylabel('Occurences');
subplot(3,2,6);
histogram(hist31v);
title('Valence Diff Labeler 3-1');
xlabel('Value');
ylabel('Occurences');

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
saveas(gcf, ['Co-occurence Matrix Final Ratings.png'])



%% MIR Toolbox

% cd(data_dir);
% music_data = miraudio('Folder');
% cd('../../');

for k=1:size(valence,1)
    % music_data = miraudio([data_dir 'file1.wav'], 'Sampling', newFs);
    music_data = miraudio(data{k}, newFs);

    % Roughness
    [roughness_data, peaks_data] = mirroughness(music_data);
    rough_median = mirgetdata(mirmedian(roughness_data));
    roughness_data_t = mirgetdata(roughness_data);

    roughness_mean = mirgetdata(mirmean(roughness_data));
    roughness_std = mirgetdata(mirstd(roughness_data));
    small_roughness_mean = mean(find(roughness_data_t < rough_median));
    big_roughness_mean = mean(find(roughness_data_t > rough_median));

    % Fluctuation
    fluctuation_data = mirfluctuation(music_data, 'Summary');

    fluctuation_mean = mean(mirgetdata(fluctuation_data));
    fluctuation_max = max(mirgetdata(fluctuation_data));

    % Key Clarity
    [key, key_clarity] = mirkey(music_data, 'Frame');

    key_clarity_mean = mirgetdata(mirmean(key_clarity));

    % Mode
    mode_data = mirmode(music_data, 'Frame');

    mode_mean = mirgetdata(mirmean(mode_data));

    % Novelty
    novelty_data = mirnovelty(music_data);

    novelty_mean = mirgetdata(mirmean(novelty_data));

    % Harmonic Change Detection
    hcdf_data = mirhcdf(music_data, 'Frame');

    hcdf_mean = mirgetdata(mirmean(hcdf_data));

    %% Find MFCCs

    % MFCCs = find_mfccs(data, 22050);
    mfccs = mirmfcc(music_data, 'Frame', 0.025, 's', 0.01, 's', 'Bands', 26, 'Delta', 0);
    mfccs_d = mirmfcc(music_data, 'Frame', 0.025, 's', 0.01, 's', 'Bands', 26, 'Delta', 1);
    mfccs_d_d = mirmfcc(music_data, 'Frame', 0.025, 's', 0.01, 's', 'Bands', 26, 'Delta', 2);

    mfcc_mean = mirgetdata(mirmean(mfccs));
    mfcc_std = mirgetdata(mirstd(mfccs));
    mfcc_d_mean = mirgetdata(mirmean(mfccs_d));
    mfcc_d_std = mirgetdata(mirstd(mfccs_d));
    mfcc_d_d_mean = mirgetdata(mirmean(mfccs_d_d));
    mfcc_d_d_std = mirgetdata(mirstd(mfccs_d_d));

    mfccs_m = sort(mirgetdata(mfccs),2);
    mfccs_d_m = sort(mirgetdata(mfccs_d),2);
    mfccs_d_d_m = sort(mirgetdata(mfccs_d_d),2);

    mfccs_low_mean = mean(mfccs_m(:,1:round(size(mfccs_m,2)/10)),2);
    mfccs_high_mean = mean(mfccs_m(:,round(size(mfccs_m,2)*0.9):size(mfccs_m,2)),2);
    mfccs_d_low_mean = mean(mfccs_d_m(:,1:round(size(mfccs_d_m,2)/10)),2);
    mfccs_d_high_mean = mean(mfccs_d_m(:,round(size(mfccs_d_m,2)*0.9):size(mfccs_d_m,2)),2);
    mfccs_d_d_low_mean = mean(mfccs_d_d_m(:,1:round(size(mfccs_d_d_m,2)/10)),2);
    mfccs_d_d_high_mean = mean(mfccs_d_d_m(:,round(size(mfccs_d_d_m,2)*0.9):size(mfccs_d_d_m,2)),2);

    features(:,k) = [roughness_mean 
                roughness_std 
                small_roughness_mean
                big_roughness_mean
                fluctuation_mean
                fluctuation_max
                key_clarity_mean
                mode_mean
                novelty_mean
                hcdf_mean
                mfcc_mean
                mfcc_std
                mfcc_d_mean
                mfcc_d_std
                mfcc_d_d_mean
                mfcc_d_d_std
                mfccs_low_mean
                mfccs_high_mean
                mfccs_d_low_mean
                mfccs_d_high_mean
                mfccs_d_d_low_mean
                mfccs_d_d_high_mean];
        
end






