function XOR_Test()
%% This fucntion will test the neural network by training it to knwo the XOR truth table
    clear all;
    close all; 
    clc;
% Define the XOR truth table in a a vectorised form
    XOR_In = [0 0 1 1; 0 1 0 1; 0 0 0 0];
    XOR_Out = [0 1 1 0;  0 0 0 0];
    alpha = 0.008;
    Nh = 3;
    W1 = rand(3 , Nh);
    W2 = rand(2 , Nh);  
    for j = 1 : 1000
        for i = 1 : 4
            [e1,W1, W2] = TwoLayer_Training(XOR_In(:,i),XOR_Out(:,i),alpha, W1, W2);
        end
        clc;
        disp('Training Percentage: ');
        disp(j/10);
    end
    % Visualise the error gradient descent
    figure;
    hold on;
    plot(e1, 'r-');
    title('Squared Error');
    hold off;
    legend('Error');
    % Checking Routine
    disp('     A     B     Y');
    for i = 1 : 4
      [o, a2hat, a2] = Network_Recognition(XOR_In(:,i),W1,W2);
      Result(:,i) = [XOR_In(1,i) XOR_In(2,i) round(o(1,1))];
    end
    disp(Result');
end 




