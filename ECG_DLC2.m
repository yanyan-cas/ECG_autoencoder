addpath sae2/
addpath softmax/
addpath data_pro/
%init params
inputSize  = 340;     % every wave has 340 points
hiddenSizeL1 =  200;     % hidden nodes nymbers
hiddenSizeL2 = 100;
numClasses  = 5;       % 5 classes
beta = 3;            % weight of sparsity penalty term      
lambda = 1e-4;        % weight decay parameter       
sparsityParam = 0.1;  % desired average activation of the hidden units.
%% ======================================================================
%  Load MIT data
divcon;
%% ======================================================================
%  we random pick 100 records from 400 people. each record has about 24H sigals
%  A batch has each person's 30 minus ECG
%  One batch has about 200000 windows
%  Train the sparse autoencoder with massive ECG data
%  This trains the sparse autoencoder on the unlabeled training

sae1OptTheta = initializeParameters(hiddenSizeL1, inputSize); %  Randomly initialize the parameters
sae2OptTheta = initializeParameters(hiddenSizeL2, hiddenSizeL1);
for i = 1 : 5
    batch_data = batch_H_data(i);
    batch_data_size = size(batch_data,2);
    if batch_data_size > 200000
        mix1 = randperm(size(unlabeledData,2),20000);
        mix2 = randperm(batch_data_size,100000);
        batch_data = [batch_data(:,mix2),unlabeledData(:,mix1)];
        [sae1OptTheta,sae2OptTheta] = batch_trainAE( sae1OptTheta,sae2OptTheta,batch_data );
    end
end     
clear mix1 mix2 batch_data unlabeledData
%% =====================================================================
%  Extract Features from the Supervised Dataset

[train1Features] = feedForwardAutoencoder(sae1OptTheta, hiddenSizeL1, inputSize, trainSet);
[train2Features] = feedForwardAutoencoder(sae2OptTheta, hiddenSizeL2, hiddenSizeL1, train1Features);                         
 
%% ======================================================================
%  Use softmaxTrain.m to train a multi-class classifier. 
saeSoftmaxTheta = 0.005 * randn(hiddenSizeL2 * numClasses, 1);
addpath minFunc/
options.Method = 'lbfgs'; 
options.maxIter = 200;	
options.display = 'on';
softmaxModel = softmaxTrain(hiddenSizeL2, numClasses, lambda, ...
                            train2Features, trainlabels, options);

%% ====================================================================================
% Initialize the stack using the parameters learned
stack = cell(2,1);
stack{1}.w = reshape(sae1OptTheta(1:hiddenSizeL1*inputSize), ...
                     hiddenSizeL1, inputSize);
stack{1}.b = sae1OptTheta(2*hiddenSizeL1*inputSize+1:2*hiddenSizeL1*inputSize+hiddenSizeL1);
stack{2}.w = reshape(sae2OptTheta(1:hiddenSizeL2*hiddenSizeL1), ...
                     hiddenSizeL2, hiddenSizeL1);
stack{2}.b = sae2OptTheta(2*hiddenSizeL2*hiddenSizeL1+1:2*hiddenSizeL2*hiddenSizeL1+hiddenSizeL2);

% Initialize the parameters for the deep model
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [ softmaxModel.optTheta(:) ; stackparams ];
options.maxIter = 600;
% Finetune softmax model
[stackedAEOptTheta, cost3] = minFunc( @(p) stackedAECost(p, ...
                                   inputSize, hiddenSizeL2, ...
                                   numClasses, netconfig, ...
                                   lambda, trainSet,trainlabels), ...
                              stackedAETheta, options);

%% ====================================================================================

%test
% Classification Score
[pred] = stackedAEPredict(stackedAETheta, inputSize, hiddenSizeL2, ...
                          numClasses, netconfig, testSet);

acc = mean(testlabels(:) == pred(:));
fprintf('Before Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

[pred] = stackedAEPredict(stackedAEOptTheta, inputSize, hiddenSizeL2, ...
                          numClasses, netconfig, testSet);

acc = mean(testlabels(:) == pred(:));
fprintf('After Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

stack = params2stack(stackedAEOptTheta(hiddenSizeL2*numClasses+1:end), netconfig);
save RESULT/opt221-nof.mat sae1OptTheta sae2OptTheta stackedAEOptTheta pred testlabels netconfig
%99.129%