clc; clear all; close all;

%% Pattern Recognition Lab 2 Main

%% Initialize models

load('train_observations.mat');

%addpath(genpath('/opt/hmm/HMMall'), '-end');
addpath(genpath('/home/thymios/Downloads/HMMall'), '-end');

Ns = 15;
Nm = 2;
Niter = 10;
Nfeatures = 12;
Ndigits = size(train_resultino,1);
Nspeakers = size(train_resultino,2);

% Find the max window length so that we zero pad the feature vectors
wlen = zeros(Ndigits,1);
for i = 1:Ndigits
    for j = 1:Nspeakers
        if(length(train_resultino{i,j}) > wlen(i))
            wlen(i) =length(train_resultino{i,j});
        end
    end
end

prior1 = cell(9,1);
transmat1 = cell(9,1);
mu1 = cell(9,1);
Sigma1 = cell(9,1);
mixmat1 = cell(9,1);
LL = cell(9,1);


for dig = 1:9
    % Zero Pad the feature vectors
    train_data = zeros(Nfeatures, wlen(dig), Nspeakers);
    j = 1;
    k = 1;
    while j <= Nspeakers
        size1 = size(train_resultino{dig,j}',1);
        size2 = size(train_resultino{dig,j}',2);
        if(size2 ~= 1)
            train_data(:,1:size2,k) = train_resultino{dig,j}(:,2:13)';
            k = k + 1;
        end
        j = j + 1;
    end

    prior0 = [1 ; zeros(Ns-1,1)];
    transmat0 = triu(ones(Ns)) - triu(ones(Ns), 2);
    transmat0 = mk_stochastic(transmat0);


    % Maybe diagonal cov_type
    %[mu0, Sigma0] = mixgauss_init(Ns*Nm, reshape(train_data, [Nfeatures Nspeakers*wlen(dig)]), 'diag', 'rnd');
    
    % Manual mu and sigma
    Sigma0 = repmat(10*eye(Nfeatures), [1 1 Ns Nm]);
    temp_mu = mean(mean(train_data,3),2);
    
    % Simple way that doesnt use the many gaussians 
    mu0 = repmat(temp_mu, [1 Ns Nm]);
    
    % Kmeans
    [idx, mu0temp] = kmeans(reshape(train_data, [Nfeatures Nspeakers*wlen(dig)])', Nm);
    for i = 1:Nm
       mu0(:,:,i) = repmat(mu0temp(i,:)', [1 Ns]); 
    end
    
    % The following two lines might be useless
    mu0 = reshape(mu0, [Nfeatures Ns Nm]);
    Sigma0 = reshape(Sigma0, [Nfeatures Nfeatures Ns Nm]);

    mixmat0 = mk_stochastic(ones(Ns, Nm));

    display(dig);
    [LL{dig}, prior1{dig}, transmat1{dig}, mu1{dig}, Sigma1{dig}, mixmat1{dig}] = ...
        mhmm_em(train_data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', Niter, 'verbose', 0, 'cov_type', 'diag');
   
end

%% Plot LL Model
k1 = 7;
load('LL1Gauss.mat');
load('LL2Gauss.mat');
load('LL3Gauss.mat');
figure();
hold on;
plot(LL1{k1});
plot(LL2{k1});
plot(LL3{k1});
hold off;
title('Log Likelihood Convergence Diagram');
xlabel('Iterations');
ylabel('Log Likelihood');
legend('Nm = 1', 'Nm = 2', 'Nm = 3');


%% Evaluate model
load('test_observations.mat');

clas = zeros(9,4);
correct = 0;
LogLat = zeros(36,9);
SelectedLat = zeros(36,9);
Number_decisions = zeros(1,9);
for k = 1:9
    for j = 1:4
        for i = 1:9
            loglik(i) = mhmm_logprob(test_resultino{k,j}(:,2:13)', prior1{i}, transmat1{i}, mu1{i}, Sigma1{i}, mixmat1{i});
            LogLat((j-1)*9+k,i) = loglik(i);
        end
        [~, clas(k,j)] = max(loglik);
        Number_decisions(clas(k,j)) = Number_decisions(clas(k,j)) + 1;
        if clas(k,j) == k
            correct = correct + 1;
        else
            display(k)
            display(j)
        end
    end
end
digits(5)
latex(vpa(sym(LogLat),5));
latex(sym(Number_decisions));
display(correct/ 36);

%% Confusion Matrix
confusion = zeros(9);
for i = 1:9
    for j = 1:4
        confusion(i,clas(i,j)) = confusion(i,clas(i,j)) + 1;
    end
end

%% Viterbi 
i = k1;
figure;
subplot(1,2,1); 
hold on;
for j = 1:4
    % The model that it classified
    % k = clas(i,j);
    % The model that should have classified
    k = i;
    B = mixgauss_prob(test_resultino{i,j}(:,2:13)', mu1{k}, Sigma1{k}, mixmat1{k});
    [path] = viterbi_path(prior1{k}, transmat1{k}, B);
    plot(path);
end
hold off;
title('Viterbi Execution on test occurences of digit 7');
xlabel('Windows');
ylabel('States');
legend('Test-1', 'Test-2', 'Test-3', 'Test-4');  


subplot(1,2,2);
hold on;
for j = 1:11
    % The model that it classified
    % k = clas(i,j);
    % The model that should have classified
    k = i;
    B = mixgauss_prob(train_resultino{i,j}(:,2:13)', mu1{k}, Sigma1{k}, mixmat1{k});
    [path] = viterbi_path(prior1{k}, transmat1{k}, B);
    plot(path);
end

hold off;
title('Viterbi Execution on train occurences of digit 7');
xlabel('Windows');
ylabel('States');
legend('Train-1', 'Train-2', 'Train-3', 'Train-4', 'Train-5', 'Train-6', 'Train-7', 'Train-8', 'Train-9', 'Train-10', 'Train-11');  
