function NhInvestigation()
    close all;
    clear all;
    clc;

    for Nh = 1 : +1 : 20
        disp('Node Handle');
        disp(Nh);
        Inverse_Kinematics_Learn(Nh);

    end
end
