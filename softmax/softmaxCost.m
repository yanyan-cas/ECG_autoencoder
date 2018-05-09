function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data

theta = reshape(theta, numClasses, inputSize);
numCases = size(data, 2);
groundTruth = full(sparse(labels,1:numCases,1));
thetagrad = zeros(numClasses, inputSize);
cost = 0;

%Compute the cost and gradient for softmax regression.
M = theta * data;
M = bsxfun(@minus,M,max(M,[],1));
e_M = exp(M);
tmp = e_M ./ repmat(sum(e_M,1),numClasses,1);
cost = -(1 / numCases) * sum(sum((groundTruth .* log(tmp)),1)) + (lambda / 2) * trace(theta * theta');
thetagrad = (-1 / numCases ) * (groundTruth - tmp) * data' + lambda  * theta;

grad = [thetagrad(:)];

end

