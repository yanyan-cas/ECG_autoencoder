function [cost,grad] = sparseAutoencoderCost(theta, visibleSize, hiddenSize, ...
                                             lambda, sparsityParam, beta, data)

% visibleSize: the number of input units
% hiddenSize: the number of hidden units
% lambda: weight decay parameter
% sparsityParam: The desired average activation for the hidden units
% beta: weight of sparsity penalty term
% data: Our 64x10000 matrix containing the training data.  So, data(:,i) is the i-th training example. 

W1 = reshape(theta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
W2 = reshape(theta(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
b1 = theta(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
b2 = theta(2*hiddenSize*visibleSize+hiddenSize+1:end);

%initialize
cost = 0;
W1grad = zeros(size(W1)); 
W2grad = zeros(size(W2));
b1grad = zeros(size(b1)); 
b2grad = zeros(size(b2));

%  Compute the cost/optimization objective J_sparse(W,b) for the Sparse Autoencoder,
%  and the corresponding gradients W1grad, W2grad, b1grad, b2grad.

column = size(data,2);
s_h = W1 * data + repmat(b1,1,column);
%s_h = bsxfun(@plus,W1 * data,b1);
y_h = sigmoid(s_h);
s_v = W2 * y_h + repmat(b2,1,column);
%s_v = bsxfun(@plus,W2 * y_h,b2);
y_v = sigmoid(s_v);
des_v = desigmoid(s_v);
dareta2 = -(data - y_v).*des_v;
W2grad = (dareta2 * y_h')./column + lambda.*W2;
y_b = ones(1,size(data,2))./column;
b2grad = dareta2 * y_b';
des_h = desigmoid(s_h);
dareta1 = (W2' * dareta2).*des_h;
p = sum(y_h,2)./column;
tmp = (beta * des_h).* repmat(-sparsityParam ./ p + (1 - sparsityParam) ./ (1 - p),1,column);
dareta1 = dareta1 + tmp;
W1grad = (dareta1 * data')./column + lambda.* W1;
b1grad =  dareta1 * y_b';
cost = trace((y_v - data)*(y_v - data)') / 2 / column + lambda / 2 * (W1(:)' * W1(:) + W2(:)' * W2(:)) +...
    beta * sum(sparsityParam * log(sparsityParam./ p) + (1 - sparsityParam) * log((1-sparsityParam)./(1 - p)));
grad = [W1grad(:) ; W2grad(:) ; b1grad(:) ; b2grad(:)];

end

function sigm = sigmoid(x)  
    sigm = 1 ./ (1 + exp(-x));
end

function desigm = desigmoid(x)
    desigm = sigmoid(x).*(1-sigmoid(x));
end
