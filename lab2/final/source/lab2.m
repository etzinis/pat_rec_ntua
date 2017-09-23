clc; clear all; close all;

%% Pattern Recognition Lab 2

%% Read the audio files

digit_names = { 'one'
              , 'two'
              , 'three'
              , 'four'
              , 'five'
              , 'six'
              , 'seven'
              , 'eight'
              , 'nine'
              };

speakers = 1:15;
train_speaker_num = round(0.7 * 15);
data_in = cell(9,15);
data_train = cell(9, train_speaker_num);
data_test = cell(9, 15-train_speaker_num);
for i = 1:9
    train_subset = datasample(1:15, train_speaker_num, 'Replace', false);
    cond = ismember(speakers, train_subset);
    test_subset = speakers(~cond);
    train_i = 1;
    test_i = 1;
    for j = 1:15
        name = strcat('data/', digit_names{i,1}, int2str(j), '.wav');
        if exist(name, 'file') == 2
            [y, Fs] = audioread(name);   
            data_in(i,j) = {y};
            if(ismember(j,train_subset))
                data_train(i,train_i) = {y};
                train_i = train_i + 1;
            else
                data_test(i,test_i) = {y};
                test_i = test_i + 1;
            end
        end
    end
end

%% Use the pre emphasis filter

B = [1 -0.97];

for i = 1:9
    for j = 1:15
        data_preemph(i,j) = {filter(B,1,data_in{i,j})};
    end
end

% sound(data_in{8,10}, Fs);
% sound(data_preemph{8,10}, Fs);

%% Separate signal and filter using Hamming Window
T = 0.025; % In seconds
Tov = 0.010; % In seconds

NT = T * Fs;
NTov = Tov * Fs;


w = hamming(400);
data_windowed = cell(9,15);
for i = 1:9
    for j = 1:15
        data_curr = data_preemph{i,j};
        Nf = floor(length(data_curr) / (NT-NTov));
        data_curr = vertcat(data_curr, zeros(NT,1));
        framed = zeros(max(Nf,1), NT);
        for k = 1:Nf
            curr_inds = (1:NT) + (k-1)*(NT-NTov);
            framed(k,:) = data_curr(curr_inds).*w;
        end
        data_windowed(i,j) = {framed};
    end
end



%% Mel Filtering

% Calculate the Mel Triangular Filters
Q = 24;
max_mel = 2595 * log(1+ (Fs/2)/ 700);
min_mel = 2595 * log(1+ 300/ 700);
fc_mel = linspace(min_mel,max_mel,Q+2);
fc = 700 * (exp(fc_mel./2595) - 1);

fc_mel_fft = round(fc.*NT./Fs);
filterbank = cell(24,1);
for i = 2:(length(fc_mel_fft)-1)
    start1 = fc_mel_fft(i-1);
    end1 = fc_mel_fft(i+1);
    mid1 = fc_mel_fft(i);
    filterbank(i-1) = {triangly(start1, mid1, end1)};
end

% Plot filterbank
% figure;
% hold on;
% for i = 1:length(filterbank)
%     start1 = fc_mel_fft(i);
%     end1 = fc_mel_fft(i+2);
%     temp = zeros(200,1);
%     temp(start1:end1) = filterbank{i};
%     plot((1:200).*(Fs/400) ,temp);
% end
% hold off;

%% Apply the filterbank to the windowed sample

data_filtered = cell(9,15);
data_energy = cell(9,15);
data_energy_g = cell(9,15);
for i = 1:9
    for j = 1:15
        dtemp = data_windowed{i,j};
        filtered = cell(size(dtemp,1), size(filterbank,1));
        energy = zeros(size(dtemp,1), size(filterbank,1));
        for k = 1:size(dtemp,1)
            data_fft = abs(fft(dtemp(k,:)));
            
            for k1 = 1:size(filterbank,1)
                start1 = fc_mel_fft(k1);
                end1 = fc_mel_fft(k1+2);
                filtered_temp = data_fft(start1:end1).*filterbank{k1};
                filtered(k,k1) = {filtered_temp};
                energy(k,k1) = sum(filtered_temp.^2);
            end
        end
        data_filtered(i,j) = {filtered};
        data_energy(i,j) = {energy};
        data_energy_g(i,j) = {log(energy)};
    end
end

% Plot the energy coefs
% figure;
% hold on;
% plot(data_energy_g{5,5}(19,:))
% plot(data_energy_g{5,5}(27,:))
% hold off;

%% DCT-Transform on the G coeffs

Nc = 13;

data_energy_dct = cell(9,15);
for i = 1:9
    for j = 1:15
        curr = data_energy_g{i,j};
        energy_dct = zeros(size(curr,1),size(curr,2));
        for k = 1:size(curr,1)
            energy_dct(k,:) = dct(curr(k,:));
        end
        data_energy_dct(i,j) = {energy_dct(:,1:Nc)};
    end
end

%% Plot the Histograms

k1 = 7;
k2 = 5;

n1 = 12;
n2 = 5;

k1_n1_cs = [];
k1_n2_cs = [];
k2_n1_cs = [];
k2_n2_cs = [];
for j = 1:15
    temp11 = data_energy_dct{k1,j}(:,n1);
    temp12 = data_energy_dct{k1,j}(:,n2);
    k1_n1_cs = vertcat(k1_n1_cs,temp11);
    k1_n2_cs = vertcat(k1_n2_cs,temp12);
    temp21 = data_energy_dct{k2,j}(:,n1);
    temp22 = data_energy_dct{k2,j}(:,n2);
    k2_n1_cs = vertcat(k2_n1_cs,temp21);
    k2_n2_cs = vertcat(k2_n2_cs,temp22);
end

figure;
subplot(2,2,1);
histogram(k1_n1_cs);
title('Digit 7 - Coeff 12');
subplot(2,2,2);
histogram(k1_n2_cs);
title('Digit 7 - Coeff 5');
subplot(2,2,3);
histogram(k2_n1_cs);
title('Digit 5 - Coeff 12');
subplot(2,2,4);
histogram(k2_n2_cs);
title('Digit 5 - Coeff 5');

%% Reconstruct the frames

% data_energy_g{5,5}(19,:)
% data_energy_g{5,5}(27,:)

data_energy_reconstructed_5_5_19 = exp( idct(data_energy_dct{5,5}(19,:),Q) );
data_energy_reconstructed_5_5_27 = exp( idct(data_energy_dct{5,5}(27,:),Q) );


% Plot the energy coefs
figure;
subplot(1,2,1);
xlabel('Filter Index')
ylabel('Amplitude')
hold on;
plot(data_energy{5,5}(19,:))
plot(data_energy_reconstructed_5_5_19)
hold off;


subplot(1,2,2);
xlabel('Filter Index')
ylabel('Amplitude')
hold on;
plot(data_energy{5,5}(27,:))
plot(data_energy_reconstructed_5_5_27)
hold off;

%% Mean Values

data_mean_values = zeros(i,j,2);
for i = 1:9
    for j = 1:15
        curr = data_energy_dct{i,j};
        mean1 = mean(curr(:,1));
        mean2 = mean(curr(:,2));
        data_mean_values(i,j,1) = mean1;
        data_mean_values(i,j,2) = mean2;
    end
end

% scatter(x,y,25,c,'filled')

xs = [];
ys = [];
cs = [];
c = 1;
index = 1;
for i = 1:9
    for j = 1:15
        cond1 = not(isnan(data_mean_values(i,j,1)));
        cond2 = not(isinf(data_mean_values(i,j,1)));
        cond3 = not(isnan(data_mean_values(i,j,2)));
        cond4 = not(isinf(data_mean_values(i,j,2)));
        if  cond1 & cond2 & cond3 & cond4
            xs(index) = data_mean_values(i,j,1);
            ys(index) = data_mean_values(i,j,2);
            cs(index) = c;
            index = index + 1;
        end
    end
    c = c + 1;
end

mean_x = [];
mean_y = [];
mean_c = [];
c = 1;
for i = 1:9
    cond1 = not(isnan(data_mean_values(i,:,1)));
    cond2 = not(isinf(data_mean_values(i,:,1)));
    cond3 = not(isnan(data_mean_values(i,:,2)));
    cond4 = not(isinf(data_mean_values(i,:,2)));
    condition = cond1 & cond2 & cond3 & cond4;
    mean_x(i) = mean(data_mean_values(i,condition,1));
    mean_y(i) = mean(data_mean_values(i,condition,2));
    mean_c(i) = c;
    c = c + 1;
end

mrkrs = ['o' '<' '>' 's' 'd' 'p' 'h' '^' 'v'];
figure;
hold on;
scatter(xs,ys,25,cs)
for i = 1:9
    scatter(mean_x(i),mean_y(i),200,mean_c(i),'filled',mrkrs(i))
end
hold off;

legend('Speaker Means', 'Digit 1', 'Digit 2', 'Digit 3', 'Digit 4', 'Digit 5', 'Digit 6', 'Digit 7', 'Digit 8', 'Digit 9' )



% Find maximum length for each digit
maxim = zeros(9,1);
for i = 1:9
    for j = 1:15
        if(length(data_in{i,j}) > maxim(i))
            maxim(i) = length(data_in{i,j}); 
        end
    end
end
    

padded_test = cell(9,size(data_test,2));
for i = 1:9
    for j = 1:size(data_test,2)
        pad_total = maxim(i) - length(data_test{i,j});
        front_pad = floor(pad_total/2);
        back_pad = pad_total - front_pad;
        %front_padded = padarray(data_test{i,j},[front_pad 0], 0, 'pre');
        %padded = padarray(front_padded ,[back_pad 0], 0, 'post');
        padded = padarray(data_test{i,j} ,[pad_total 0], 'symmetric', 'post');
        padded_test(i,j) = {padded};
    end
end

padded_train = cell(9,size(data_train,2));
for i = 1:9
    for j = 1:size(data_train,2)
        pad_total = maxim(i) - length(data_train{i,j});
        front_pad = floor(pad_total/2);
        back_pad = pad_total - front_pad;
        % front_padded = padarray(data_train{i,j},[front_pad 0], 'symmetric', 'pre');
        % padded = padarray(front_padded ,[back_pad 0], 'symmetric', 'post');
        padded = padarray(data_train{i,j} ,[pad_total 0], 'symmetric', 'post');
        padded_train(i,j) = {padded};
    end
end



train_resultino = find_mfccs(padded_train, Fs);
test_resultino = find_mfccs(padded_test, Fs);

save('train_observations', 'train_resultino');
save('test_observations', 'test_resultino');
