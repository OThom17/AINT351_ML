function Configurations(thetas)
%% Housekeeping
    %clear all;
    %close all;
    %clc;
%% Constants
    armLen = [0.5 0.5];
    origin = [0,0];
%  Random Generation of Values 
%    Samples = 10;
%     a = 0;
%     b = -pi;
%     thetas = (b-a).*rand(2,Samples) + b; 
%% Generate Data
    [~,n] = size(thetas);
    for i = 1 : n
        [Pos1(:,i), Pos2(:,i)] = RevoluteForwardKinematics2D(armLen, thetas(:,i), origin);
    end
% Visualise
    figure();
    hold on;
for i = 1 : n
    hc = plot([Pos2(1,i), Pos1(1,i),  origin(1)] , [Pos2(2,i), Pos1(2,i), origin(2)] ,'b-', 'lineWidth' , 2);
    h2 = plot(Pos2(1,i),Pos2(2,i), 'ro', 'lineWidth', 2);
    h1 = plot(Pos1(1,i), Pos1(2,i), 'go' , 'lineWidth', 2);
end
    plot(origin(1), origin(2), 'k*', 'MarkerSize', 10, 'lineWidth', 1);
    title('ISR: Arm Configurations');
    xlabel('x(m)');
    ylabel('y(m)');
    legend([h1 h2], 'Elbow', 'End Effector');
    hold off;
end
