function [theta_N0_Reshape, Pos2_N0_Reshape] = ReducedDisplayWorkspace(Samples)
%% Housekeeping
    %clear all;
%    close all;
    %clc;
 %% Constants
    armLen = [0.5 0.5];
    origin = [0 0];

   %Samples = 4000;
   
    % Base Joint
    a = 0;
    b = -pi;

    theta = (b-a).*rand(2,Samples) + b;   
    idx = 1;
%% Generate Data
for i = 1 : Samples
    [Pos1(:,i), Pos2(:,i)] = RevoluteForwardKinematics2D(armLen, theta(:,i), origin);
    if (Pos2(1,i) > 0)
        Pos2(:,i) = 0;
        theta(:,i) = 0;
        idx = idx + 1;
    elseif (Pos2(2,i) > 0.5)
        Pos2(:,i) = 0;
        theta(:,i) = 0;
        idx = idx + 1;
    end
end

Pos2_Non_Zero = nonzeros(Pos2');
Cols = Samples-idx;
Pos2_N0_Reshape = reshape(Pos2_Non_Zero,Cols+1,2)';


theta_Non_Zero = nonzeros(theta');
Cols = Samples-idx;
theta_N0_Reshape = reshape(theta_Non_Zero,Cols+1,2)';

% Visualise
    figure;
    hold on;
for i = 1 : Cols
    hp = plot(Pos2_N0_Reshape(1,i), Pos2_N0_Reshape(2, i), 'r.');
end
    ho = plot(origin(1), origin(2), 'k*');
    title('ISH: Endpoint Locations');
    xlabel('x(m)');
    ylabel('y(m)');
    legend([hp ho], 'Endpoint', 'Origin');
    ylim([-0.6 1])
    xlim([-1.1 0.5])
    hold off;
end

