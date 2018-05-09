addpath sae5/
addpath softmax/
addpath data_pro/
%init params
inputSize  = 340;     % every wave has 340 points
hiddenSizeL1 =  200;     % hidden nodes nymbers
hiddenSizeL2 = 100;
hiddenSizeL3 = 100;
hiddenSizeL4 = 100;
numClasses  = 5;       % 5 classes
beta = 3;            % weight of sparsity penalty term      
lambda = 1e-4;        % weight decay parameter       
sparsityParam = 0.1;  % desired average activation of the hidden units.
%% ======================================================================
%  Load MIT data
load RESULT/opt221-1.mat
prestack = params2stack(stackedAEOptTheta(hiddenSizeL2*numClasses+1:end), netconfig);
sae1OptTheta = [prestack{1}.w(:);prestack{1}.w(:);prestack{1}.b(:);prestack{1}.b(:)];                     % [W1(:) ; W2(:) ; b1(:) ; b2(:)];
sae2OptTheta = [prestack{2}.w(:);prestack{2}.w(:);prestack{2}.b(:);prestack{2}.b(:)];  
clear testlabels pred stackedAEOptTheta netconfig
divcon;
%% ======================================================================
%  we random pick 100 records from 400 people. each record has about 24H sigals
%  A batch has each person's 30 minus ECG
%  One batch has about 200000 windows
%  Train the sparse autoencoder with massive ECG data
%  This trains the sparse autoencoder on the unlabeled training
sae3OptTheta = initializeParameters(hiddenSizeL3, hiddenSizeL2);
sae4OptTheta = initializeParameters(hiddenSizeL4, hiddenSizeL3); %  Randomly initialize the parameters
for i = 1 : 5
    fprintf('Training the %dth batch........\n',i);
    batch_data = batch_H_data(i);
    batch_data_size = size(batch_data,2);
    if batch_data_size > 200000
        mix1 = randperm(size(unlabeledData,2),20000);
        mix2 = randperm(batch_data_size,100000);
        batch_data = [batch_data(:,mix2),unlabeledData(:,mix1)];
        [sae3OptTheta,sae4OptTheta] = batch_trainAE( sae1OptTheta,sae2OptTheta,...
                                sae3OptTheta , sae4OptTheta, batch_data );
    end
end     
clear mix1 mix2 batch_data unlabeledData
%% =====================================================================
%  Extract Features from the Supervised Dataset

[train1Features] = feedForwardAutoencoder(sae1OptTheta, hiddenSizeL1, inputSize, trainSet);
[train2Features] = feedForwardAutoencoder(sae2OptTheta, hiddenSizeL2, hiddenSizeL1, train1Features);                         
[train3Features] = feedForwardAutoencoder(sae3OptTheta, hiddenSizeL3, hiddenSizeL2, train2Features);                         
[train4Features] = feedForwardAutoencoder(sae4OptTheta, hiddenSizeL4, hiddenSizeL3, train3Features);                         
 
%% ======================================================================
%  Use softmaxTrain.m to train a multi-class classifier. 
saeSoftmaxTheta = 0.005 * randn(hiddenSizeL3 * numClasses, 1);
addpath minFunc/
options.Method = 'lbfgs'; 
options.maxIter = 200;	
options.display = 'on';
softmaxModel = softmaxTrain(hiddenSizeL4, numClasses, lambda, ...
                            train4Features, trainlabels, options);

%% ====================================================================================
% Initialize the stack using the parameters learned
stack = cell(4,1);
stack{1}.w = reshape(sae1OptTheta(1:hiddenSizeL1*inputSize), ...
                     hiddenSizeL1, inputSize);
stack{1}.b = sae1OptTheta(2*hiddenSizeL1*inputSize+1:2*hiddenSizeL1*inputSize+hiddenSizeL1);
stack{2}.w = reshape(sae2OptTheta(1:hiddenSizeL2*hiddenSizeL1), ...
                     hiddenSizeL2, hiddenSizeL1);
stack{2}.b = sae2OptTheta(2*hiddenSizeL2*hiddenSizeL1+1:2*hiddenSizeL2*hiddenSizeL1+hiddenSizeL2);
stack{3}.w = reshape(sae3OptTheta(1:hiddenSizeL3*hiddenSizeL2), ...
                     hiddenSizeL3, hiddenSizeL2);
stack{3}.b = sae3OptTheta(2*hiddenSizeL3*hiddenSizeL2+1:2*hiddenSizeL3*hiddenSizeL2+hiddenSizeL3);
stack{4}.w = reshape(sae4OptTheta(1:hiddenSizeL4*hiddenSizeL3), ...
                     hiddenSizeL4, hiddenSizeL3);
stack{4}.b = sae3OptTheta(2*hiddenSizeL4*hiddenSizeL3+1:2*hiddenSizeL4*hiddenSizeL3+hiddenSizeL4);

% Initialize the parameters for the deep model
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [ softmaxModel.optTheta(:) ; stackparams ];
options.maxIter = 600;
% Finetune softmax model
[stackedAEOptTheta, cost4] = minFunc( @(p) stackedAECost(p, ...
                                   inputSize, hiddenSizeL4, ...
                                   numClasses, netconfig, ...
                                   lambda, trainSet,trainlabels), ...
                              stackedAETheta, options);

%% ====================================================================================

%test
% Classification Score
[pred] = stackedAEPredict(stackedAETheta, inputSize, hiddenSizeL4, ...
                          numClasses, netconfig, testSet);

acc = mean(testlabels(:) == pred(:));
fprintf('Before Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

[pred] = stackedAEPredict(stackedAEOptTheta, inputSize, hiddenSizeL4, ...
                          numClasses, netconfig, testSet);

acc = mean(testlabels(:) == pred(:));
fprintf('After Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

stack = params2stack(stackedAEOptTheta(hiddenSizeL4*numClasses+1:end), netconfig);
save RESULT\opt32111.mat stackedAEOptTheta pred netconfig sae2OptTheta sae1OptTheta sae3OptTheta testlabels
