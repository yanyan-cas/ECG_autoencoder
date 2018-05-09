function [pred] = stackedAEPredict(theta, inputSize, hiddenSize, numClasses, netconfig, data)
                                         
% stackedAEPredict: Takes a trained theta and a test data set,
% and returns the predicted labels for each example.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% data: Our matrix containing the training data as columns.  So, data(:,i) is the i-th training example. 

% compute the softmax gradient
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);

% Extract out the "stack"
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);

%  I Compute pred using theta assuming that the labels start from 1.
pred = zeros(1, size(data, 2));
aedatah1 = sigmoid(stack{1}.w * data + repmat(stack{1}.b,1,size(data,2)));
aedatah2 = sigmoid(stack{2}.w * aedatah1 + repmat(stack{2}.b,1,size(data,2)));
aedatah3 = sigmoid(stack{3}.w * aedatah2 + repmat(stack{3}.b,1,size(data,2)));
eachValue = zeros(size(softmaxTheta,1),size(data,2));
eachValue = softmaxTheta * aedatah3;
[~,pred] = max(eachValue);

end

function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end
