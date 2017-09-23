function [ result ] = find_mfccs( data_in, Fs )
%FIND_MFCCS Summary of this function goes here
%   Detailed explanation goes here

%% Initial Parameters
number_of_songs = 412;

%% Use the pre emphasis filter

B = [1 -0.97];

for i = 1:number_of_songs
    data_preemph(i) = {filter(B,1,data_in{i})};
end

%% Separate signal and filter using Hamming Window
T = 0.025; % In seconds
Tov = 0.010; % In seconds

NT = round(T * Fs);
NTov = round(Tov * Fs);


w = hamming(NT);
data_windowed = cell(number_of_songs);
for i = 1:number_of_songs
    data_curr = data_preemph{i};
    Nf = floor(length(data_curr) / (NT-NTov));
    data_curr = vertcat(data_curr, zeros(NT,1));
    framed = zeros(max(Nf,1), NT);
    for k = 1:Nf
        curr_inds = (1:NT) + (k-1)*(NT-NTov);
        framed(k,:) = data_curr(curr_inds).*w;
    end
    data_windowed(i) = {framed};
end



%% Mel Filtering

% Calculate the Mel Triangular Filters
Q = 26;
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

%% Apply the filterbank to the windowed sample

data_filtered = cell(number_of_songs);
data_energy = cell(number_of_songs);
data_energy_g = cell(number_of_songs);
for i = 1:number_of_songs
    dtemp = data_windowed{i};
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
    data_filtered(i) = {filtered};
    data_energy(i) = {energy};
    data_energy_g(i) = {log(energy)};
end

%% DCT-Transform on the G coeffs

Nc = 13;

data_energy_dct = cell(number_of_songs);
for i = 1:number_of_songs
    curr = data_energy_g{i};
    energy_dct = zeros(size(curr,1),size(curr,2));
    for k = 1:size(curr,1)
        energy_dct(k,:) = dct(curr(k,:));
    end
    data_energy_dct(i) = {energy_dct(:,1:Nc)};
end



result = data_energy_dct;



end

