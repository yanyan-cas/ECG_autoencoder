function [pred] = softmaxPredict(softmaxModel, data)

% softmaxModel - model trained using softmaxTrain
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% Unroll the parameters from theta
theta = softmaxModel.optTheta;
pred = zeros(1, size(data, 2));
eachValue = zeros(size(theta,1),size(data,2));
eachValue = theta * data;
[~,pred] = max(eachValue);

end

