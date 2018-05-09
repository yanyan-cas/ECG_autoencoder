function [softmaxModel] = softmaxTrain(inputSize, numClasses, lambda, inputData, labels, options)

% inputSize: the size of an input vector x^(i)
% numClasses: the number of classes 
% lambda: weight decay parameter
% inputData: an N by M matrix containing the input data
% labels: M by 1 matrix containing the class labels 
% options (optional): options

if ~exist('options', 'var')
    options = struct;
end

if ~isfield(options, 'maxIter')
    options.maxIter = 400;
end

% initialize parameters
theta = 0.005 * randn(numClasses * inputSize, 1);
% Use minFunc to minimize the function
addpath minFunc/
options.Method = 'lbfgs'; 
options.display = 'on';
[softmaxOptTheta, cost] = minFunc( @(p) softmaxCost(p, ...
                                   numClasses, inputSize, lambda, ...
                                   inputData, labels), ...                                   
                              theta, options);
    %theta, numClasses, inputSize, lambda, data, labels
% Fold softmaxOptTheta into other format
softmaxModel.optTheta = reshape(softmaxOptTheta, numClasses, inputSize);
softmaxModel.inputSize = inputSize;
softmaxModel.numClasses = numClasses;
                          
end                          
