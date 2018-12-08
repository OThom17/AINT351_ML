function [thetas] = KinematicControl(W1, W2, targets)
    [thetas, ~, ~] = Network_Recognition(targets,W1,W2);
end
