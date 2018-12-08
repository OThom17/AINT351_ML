%% Sigmoid
function [o, a2] = Sigmoid(X,W1,W)
    net2 = W1 * X';
    a2 = (1 / (1 + exp(-net2)));
  
    net3 = W2 * a2';
    o = (1 / (1 + exp(-net3)));
end
