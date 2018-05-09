clear all;clc;
[wdata,labels] = extract();
labels = remap_labels(labels);
rp = randperm(800,200);
expertSet = wdata(:,rp);
expertAnn = labels(:,rp);
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

dsize = size(wdata,2);
seg = dsize / 900;

prepred = [];
postpred = [];
timeseq = [];

tic();
% get data every 30S
for i = 1:900
    fprintf('%d:\n',i);
    [w,l] = extract();
    frag = wdata(:,floor((i-1) * seg + 1):floor(i * seg));
    pred = stackedAEPredict(softmaxTheta, stack, frag);
    %pause(3);
    ut = toc();
    timeseq = [timeseq,ut];
    fprintf('%f\n',ut);
    if i < 31
        prepred = [prepred,pred];
    else
        postpred = [postpred,pred];
    end
    
    if i == 600
        %  Use softmaxTrain.m to fine-tuning the multi-class classifier.
        fbdata = [expertSet,ftts];
        fblabels = [expertAnn,fttl];
        aedatah1 = sigmoid(stack{1}.w * fbdata + repmat(stack{1}.b,1,size(fbdata,2)));
        aedatah2 = sigmoid(stack{2}.w * aedatah1 + repmat(stack{2}.b,1,size(fbdata,2))); 
        addpath minFunc/
        options.maxIter = 100;	
        softmaxModel = softmaxTrain(hiddenSizeL2, numClasses, lambda, ...
                                    aedatah2, fblabels, softmaxTheta(:), options);
        softmaxTheta = softmaxModel.optTheta;
    end
end

pred = [prepred,postpred];
acc = mean(labels(:) == pred(:));
fprintf('Test Accuracy: %0.3f%%\n', acc * 100);


