clear all;clc;
[wdata,labels] = extract();
% initalize the parameters
inputSize  = 340;     % every wave has 340 points
hiddenSizeL1 =  200;     % hidden nodes nymbers
hiddenSizeL2 = 100;
numClasses  = 5;       % 5 classes
lambda = 1e-4;        % weight decay parameter 
load ft.mat
load dl.mat
% Extract out the "softmaxTheta"
softmaxTheta = reshape(stackedAEOptTheta(1:hiddenSizeL2*numClasses), numClasses, hiddenSizeL2);
% Extract out the "stack"
stack = params2stack(stackedAEOptTheta(hiddenSizeL2*numClasses+1:end), netconfig);

pred = stackedAEPredict(softmaxTheta, stack, wdata);
acc = mean(labels(:) == pred(:));
fprintf('Test Accuracy: %0.3f%%\n', acc * 100);


pred = stackedAEPredict(softmaxTheta, stack, testSet);
acc = mean(testlabels(:) == pred(:));
fprintf('Test Accuracy: %0.3f%%\n', acc * 100);


pred = stackedAEPredict(softmaxTheta, stack, ftts);
acc = mean(fttl(:) == pred(:));
fprintf('Test Accuracy: %0.3f%%\n', acc * 100);