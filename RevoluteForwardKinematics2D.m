function [P1 P2] = RevoluteForwardKinematics2D(armLen, theta, origin)
%% Calculate relative forward kinematics
P1(1) = origin(1) + (armLen(1) * cos(theta(1)));
P1(2) = origin(2) + (armLen(1) * sin(theta(1)));

P2(1) = origin(1) + (armLen(1) * cos(theta(1))) + (armLen(2) * cos(theta(1) + theta(2)));
P2(2) = origin(2) + (armLen(1) * sin(theta(1))) + (armLen(2) * sin(theta(1) + theta(2)));
end
