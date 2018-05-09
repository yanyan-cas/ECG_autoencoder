function desigm = desigmoid(x)
    desigm = sigmoid(x).*(1-sigmoid(x));
end

