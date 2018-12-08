function [theta, Pos2] = DisplayWorkspace(Samples)
%% Housekeeping
    %clear all;
    %close all;
    %clc;
 %% Constants
    armLen = [0.5 0.5];
    origin = [0 0];

   % Samples = 5000;
    a = 0;
    b = -pi;
    theta = (b-a).*rand(2,Samples) + b;    
%% Generate Data
for i = 1 : Samples
    [Pos1(:,i), Pos2(:,i)] = RevoluteForwardKinematics2D(armLen, theta(:,i), origin);
end
% Visualise
    figure;
    hold on;
for i = 1 : Samples
    hp = plot(Pos2(1,i), Pos2(2, i), 'r.');
end
    ho = plot(origin(1), origin(2), 'k*');
    title('ISH: Endpoint Locations');
    xlabel('x(m)');
    ylabel('y(m)');
    legend([hp ho], 'Endpoint', 'Origin');
    hold off;
end

