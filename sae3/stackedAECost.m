function [ cost, grad ] = stackedAECost(theta, inputSize, hiddenSize, ...
                                              numClasses, netconfig, ...
                                              lambda, data, labels)
                                         
% stackedAECost: Takes a trained softmaxTheta and a training data set with labels,
% and returns cost and gradient using a stacked autoencoder model. Used for finetuning.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% netconfig:   the network configuration of the stack
% lambda:      the weight regularization penalty
% data: Our matrix containing the training data as columns.  So, data(:,i) is the i-th training example. 
% labels: A vector containing labels, where labels(i) is the label for the i-th training example

% extract the part which compute the softmax gradient
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);

% Extract out the "stack"
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);
softmaxThetaGrad = zeros(size(softmaxTheta));
stackgrad = cell(size(stack));
for d = 1:numel(stack)
    stackgrad{d}.w = zeros(size(stack{d}.w));
    stackgrad{d}.b = zeros(size(stack{d}.b));
end
cost = 0;
M = size(data, 2);
groundTruth = full(sparse(labels, 1:M, 1));

%  Compute the cost function and gradient vector for the stacked autoencoder.
dataSize = size(data,2);
y_h1 = sigmoid(stack{1}.w * data + repmat(stack{1}.b,1,dataSize));
y_h2 = sigmoid(stack{2}.w * y_h1 + repmat(stack{2}.b,1,dataSize));
y_h3 = sigmoid(stack{3}.w * y_h2 + repmat(stack{3}.b,1,dataSize));
M = softmaxTheta * y_h3;
M = bsxfun(@minus,M,max(M,[],1));
e_M = exp(M);
P = e_M ./ repmat(sum(e_M,1),numClasses,1);
dataMean = 1 /dataSize;
cost = -dataMean * sum(sum((groundTruth .* log(P)),1)) + (lambda / 2) * (softmaxTheta(:)' * softmaxTheta(:));
softmaxThetaGrad = -dataMean * (groundTruth - P) * y_h3' + lambda  * softmaxTheta;
cigma4 = -softmaxTheta' * (groundTruth - P) .* y_h3 .* (1 - y_h3);
cigma3 = stack{3}.w' * cigma4 .* y_h2 .* (1 - y_h2);
cigma2 = stack{2}.w' * cigma3 .* y_h1 .* (1 - y_h1);
stackgrad{3}.w = dataMean * (cigma4 * y_h2');
stackgrad{3}.b = mean(cigma4,2);
stackgrad{2}.w = dataMean * (cigma3 * y_h1');
stackgrad{2}.b = mean(cigma3,2);
stackgrad{1}.w = dataMean * (cigma2 * data');
stackgrad{1}.b = mean(cigma2,2);
grad = [softmaxThetaGrad(:) ; stack2params(stackgrad)];

end

function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end

function desigm = desigmoid(x)
    desigm = sigmoid(x).*(1-sigmoid(x));
end