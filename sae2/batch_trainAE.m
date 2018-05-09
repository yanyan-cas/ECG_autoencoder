function [ n_sae1OptTheta,n_sae2OptTheta ] = batch_trainAE( fw_sae1OptTheta,fw_sae2OptTheta,data_batch )
%  BATCH_TRAINAE Summary of this function goes here
%  Train the first sparse autoencoder
%  This trains the sparse autoencoder on the unlabeled training

inputSize  = 340;     % every wave has 340 points
hiddenSizeL1 =  200;     % hidden nodes nymbers
hiddenSizeL2 = 100;
hiddenSizeL3 = 100;
hiddenSizeL4 = 100;
numClasses  = 5;       % 5 classes
beta = 3;            % weight of sparsity penalty term      
lambda = 1e-4;        % weight decay parameter       
sparsityParam = 0.1;  % desired average activation of the hidden units.
addpath minFunc/
options.Method = 'lbfgs'; 
options.maxIter = 300;	
options.display = 'on';
[n_sae1OptTheta, cost1] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   inputSize, hiddenSizeL1, ...
                                   lambda, sparsityParam, ...
                                   beta, data_batch), ...
                                   fw_sae1OptTheta, options);
                         
%% ======================================================================
%Train the second sparse autoencoder
[sae1Features] = feedForwardAutoencoder(n_sae1OptTheta, hiddenSizeL1, inputSize, data_batch);
options.maxIter = 200;	
[n_sae2OptTheta, cost2] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   hiddenSizeL1, hiddenSizeL2, ...
                                   lambda, sparsityParam, ...
                                   beta, sae1Features), ...
                                   fw_sae2OptTheta, options);


end

