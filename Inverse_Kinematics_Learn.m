%% Training inverse kinematics
% Implement  two networks with a linear output each
function [W1 W2aug] = Inverse_Kinematics_Learn(Iteration, theta, EndPoints)
    %Initialise
%     close all;
%     clear all;
%     clc;
    [m,n] = size(theta);
    Samples = n;
%    [theta, EndPoints] = DisplayWorkspace(Samples);       
    Aug = ones(1,n);
    t = [theta];               
    X = [EndPoints; Aug];             % Augment X for the bias term in the first layer
    alpha = 0.0001;
    Nh = 8;
    W1 = rand(3 , Nh)';
    W2 = rand(2 , Nh);
    W2aug = [rand(2 , Nh) ones(2,1)]; % Augment W2 for the bias term in the second linear layer
        
    %[m,n] = size(X);
    iterations = 1;
    for j = 1 : iterations
        for i = 1 : n
            [e1,W1, W2aug] = TwoLayer_Training(X(:,i),t(:,i),alpha, W1,W2aug);
            disp('Two Layer Training: ');
            disp((i/n) * 100);
        end
    end 
%% Plot the squared error function
%     figure;
%     hold on;
%     plot(e1, 'r-');
%     title('Squared Error (ems)');
%     hold off;
%     legend('Squared Error');    
 %% Generate Test Data
    armLen = [0.5 0.5];
    origin = [0 0];
    Test_Samples = 2000;
    [theta, Pos2] = ReducedDisplayWorkspace(Test_Samples);
    [~,n] = size(Pos2);
%     a = 0;
%     b = -pi;
%     theta = (b-a).*rand(2,Test_Samples) + b;     % Generate random theta values
%     theta = [theta; ones(1,Test_Samples)]; % Augment the theta matrix
%% Forward kinematics for the new random data set
% for i = 1 : Samples
%     [Pos1(:,i), Pos2(:,i)] = RevoluteForwardKinematics2D(armLen, theta(:,i), origin);
% end
%% Visualise the true endpoint
%     figure;
%     hold on;
% for i = 1 : Test_Samples
%     hp = plot(Pos2(1,i), Pos2(2, i), 'r.');
% end
%     ho = plot(origin(1), origin(2), 'k*');
%     title('Forward Kin. ISH: Endpoint Locations');
%     xlabel('x(m)');
%     ylabel('y(m)');
%     legend([hp ho], 'Endpoint', 'Origin');
%     hold off;
%     
 %% Visualise the networks attempt
    figure;
    hold on;
    str = sprintf('Point Cloud of data produced from the network - Iteration: %d', Iteration);
    title(str);
    ho = plot(origin(1), origin(2), 'k*');
    for i = 1 : n
        [o, a2hat, a2] = Network_Recognition([Pos2(:,i);1],W1,W2aug);  % Returns the theta values
        [NNPos1, NNPos2] = RevoluteForwardKinematics2D(armLen, o, origin);
        hp = plot(NNPos2(1), NNPos2(2), 'r.');    
    end 
    xlabel('x(m)');
    ylabel('y(m)');
    legend([hp ho], 'Endpoint', 'Origin');
    ylim([-0.6 1])
    xlim([-1.1 0.5])
    hold off;
    
%     W1
%     W2aug
    
  %  keyboard
end
