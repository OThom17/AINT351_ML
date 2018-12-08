%% Implement a two-later network
% Generalised delta rule 

function [SumError,W1, W2aug] = TwoLayer_Training(X,t,alpha, W1, W2aug)
    for i = 1 : 10000
       % clc;
        %Forward Propagation
        [o, a2hat, a2] = Network_Recognition(X, W1, W2aug);
        
        %Delta terms - Hebbian Learning Rule
        [~,n] = size(W2aug);
        d3 = -(t - o);          % Linear delta 3
        d2 = (W2aug(:,1:n-1)' * d3) .* (a2 .* (1 - a2)); % Sigmoid layer 2 - Take the W2 without the augmented terms CHECK THE USE OF W2 and not AugW2

        %Error Gradient
        eW1 = d2 * X';
        eW2 = d3 * a2hat';      %a2' should be a a2hat'
        
        %Update Weights
        W1 = W1 - (alpha * eW1);
        W2aug = W2aug - (alpha * eW2);
        
        Error1 = sum(d3.^2);
        SumError(i) = sum(Error1);
        
      %  disp('Episodic Training: ');
      %  disp(i/5000 * 100);
    end
end
