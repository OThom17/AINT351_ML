function alphaInvestigation()
    close all;
    clear all;
    clc;

    for a = 0.01 : +0.1 : 1.1
        disp('Node Handle');
        disp(a);
        Inverse_Kinematics_Learn(a);
    end
end
