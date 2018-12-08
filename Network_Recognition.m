%% 3.1 Implement Network Recognition
% Implement a 2-layer network recogniser with 'nh' hidden units and a
% linear output
% Input 2*2 either theta or joint angle

function [o, a2hat, a2] = Network_Recognition(X,W1,W2aug)

%keyboard
     %Non-linear Lower Level
     net2 = W1 * X; % 3 x n Matrix
     a2 = (1 ./ (1 + exp(-net2)));     %Element wise operation - 2 x n
     
     % Augment A2
     [m,n] = size(a2);
     Auga2 = ones(1,n);
     a2hat = [a2; Auga2;];              %Augment for bias term  - 3 x n
     
     %Linear Ouput
     net3 = W2aug * a2hat; % 3 x n
     o = net3;  % 2 x n
end

