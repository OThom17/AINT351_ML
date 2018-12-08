function Exhaustive_IKL()
clear all;
close all;
    Samples = 5000;
    [theta, Pos2] = ReducedDisplayWorkspace(Samples);
        
    for idx = 1 : 2
        [W1{idx} W2aug{idx}] = Inverse_Kinematics_Learn(idx, theta, Pos2);
        disp('Exhaustive Progress: ');
        disp(idx*10);
    end
       keyboard;
end