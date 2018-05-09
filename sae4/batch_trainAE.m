function [n_sae3OptTheta] = batch_trainAE( fw_sae1OptTheta,fw_sae2OptTheta,fw_sae3OptTheta,data_batch )
%  BATCH_TRAINAE Summary of this function goes here
%  Train the first sparse autoencoder
%  This trains the sparse autoencoder on the unlabeled training

inputSize  = 340;     % every wave has 340 points
hiddenSizeL1 = 200;     % hidden nodes nymbers
hiddenSizeL2 = 100;
hiddenSizeL3 = 100;
beta = 3;            % weight of sparsity penalty term      
lambda = 1e-4;        % weight decay parameter       
sparsityParam = 0.1;  % desired average activation of the hidden units.
addpath minFunc/
options.Method = 'lbfgs'; 
options.maxIter = 200;	
options.display = 'on';

[sae1Features] = feedForwardAutoencoder(fw_sae1OptTheta, hiddenSizeL1, inputSize, data_batch);

%% ======================================================================
%  Train the third sparse autoencoder
[sae2Features] = feedForwardAutoencoder(fw_sae2OptTheta, hiddenSizeL2, hiddenSizeL1, sae1Features);
[n_sae3OptTheta, cost3] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   hiddenSizeL2, hiddenSizeL3, ...
                                   lambda, sparsityParam, ...
                                   beta, sae2Features), ...
                              fw_sae3OptTheta, options);
                          
end

