%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all rights reserved
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems
% Plymouth University
% A324 Portland Square
% PL4 8AA
% Plymouth, Devon, UK
% howardlab.com
% 22/09/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% run maze experiments
% you need to expand this script to run the assignment
close all
clear all
clc

% YOU NEED TO DEFINE THESE VALUES Scaling Limits
xshift = -0.825;
yshift = -0.0125;
limits = [0+xshift 0.4+xshift; 0+yshift 0.4+yshift;];

% build the maze
maze = CMazeMaze10x10(limits);

% draw the maze
maze.DrawMaze();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init the q-table
minVal = 0.01;
maxVal = 0.1;
maze = maze.InitQTable(minVal, maxVal);

% test values
state = 1;
action = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this will be used by Q-learning as follows:
q = maze.QValues(state, action);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the reward from the action on the current state
% this will be used by Q-learning as follows:
reward = maze.RewardFunction(state, action);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% build the transition matrix
maze = maze.BuildTransitionMatrix()
disp(maze.tm);
% print out values
%maze.tm;

% get the next state due to that action
% this will be used by Q-learning as follows:
resultingState = maze.tm(state, action);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % test random start
% startingState = maze.RandomStatingState();
% % print out value
% disp('Testing starting state');
% startingState

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q learining algorithm
% Convert the X and Y co-ordinates 
% Constants
disp('Q-Learning Starting');
gamma = 0.9;
alpha = 0.2; 
expRate = 0.95; 
s = maze.stateNumber(maze.stateStart(1),maze.stateStart(2)); % Convert to a stateID
goal = maze.stateNumber(maze.stateEnd(1),maze.stateEnd(2)); % Convert to a stateID
maze.QValues = QExperiment(maze.QValues,s, goal, gamma, alpha, expRate, maze.tm);
% disp('Resultant Q Table');
% maze.QValues

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q-Value Exploitation
[State_History, step_count]= QExploit(maze.QValues, alpha, gamma, goal, s, maze.tm);
% Place Xs onto the visited points
[m,n] = size(State_History);
for i = 1 : n
    y(i) = floor(State_History(i) / 10) + 1;
    x(i) = mod(State_History(i),10);
    if(x(i) == 0)   % 10s column special case
        x(i) = 10;
        y(i) = (State_History(i)/10);
    end
    if(floor(State_History(i) / 10) == 10) % 1s row special case
        y(i) = floor(State_History(i) / 10);
    end
end
% Draw
for i = 1 : n
    xoffset = 0.0125;
    yoffset = 0.0125;
    targetx(i) = (maze.textLowerPoint(x(i),y(i),1)+xoffset);
    targety(i) = (maze.textLowerPoint(x(i),y(i),2)+yoffset);
    text(targetx(i),targety(i), 'X','FontSize', 20,'Color','cyan', 'HorizontalAlignment', 'center');
    if (i < n)
        plot([targetx(i),(maze.textLowerPoint(x(i+1),y(i+1),1)+xoffset)],[targety(i),(maze.textLowerPoint(x(i+1),y(i+1),2)+yoffset)], 'c-', 'LineWidth',2);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kinematic Control Algorithm
% Specify the trajectory of the 2D arm
% Use inv kine generate the joint angles
% Scale the maze into the arms workspace
% Forward Kine to get the elbow and endpoint locations
% Taken from previous training trials
% Experiment Stochastic 2 Iteration 6
W1 = [  -0.478869648	0.367078077	0.394889742
-1.391520989	1.512138318	0.764571632
1.910819	1.338134532	0.564253534
1.690419914	0.982857837	-0.037969528
-0.802041952	0.764489214	0.988626574
-1.248267006	1.183225357	0.767939611
2.976942437	2.636567938	-0.715486071
1.781548704	0.584074322	0.857886995

	
];




W2aug = [   -0.035941169	-1.470398046	-1.028809154	-0.935140589	-0.919494848	-1.282850146	-2.772037345	-0.451326514	0.478454204
-1.5416836	-1.112647939	1.593774016	0.755518441	-1.654666665	-1.52982103	0.017946689	1.545981498	-1.649426739

];

[m,n] = size(targetx);
targets = [(targetx+0.1); (targety+0.15); ones(1,n)];   % Shift the whole maze into a reachable spot (-x)
thetas = KinematicControl(W1, W2aug, targets);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display configurations over the grid
armLen = [0.5 0.5];
origin = [0,0];
% Generate Data
[~,n] = size(thetas);
for i = 1 : n
    [Pos1(:,i), Pos2(:,i)] = RevoluteForwardKinematics2D(armLen, thetas(:,i), origin);
end
% Animate over the grid
keyboard

for i = 1 : n
    hc = plot([Pos2(1,i), Pos1(1,i),  origin(1)] , [Pos2(2,i), Pos1(2,i), origin(2)] ,'b-', 'lineWidth' , 2);
    h2 = plot(Pos2(1,i),Pos2(2,i), 'ro', 'lineWidth', 2);
    h1 = plot(Pos1(1,i), Pos1(2,i), 'go' , 'lineWidth', 2);
    pause(0.5);
end
    h3 = plot(origin(1), origin(2), 'w*', 'MarkerSize', 10, 'lineWidth', 1);
    title('ISR: Arm Configurations');
    xlabel('x(m)');
    ylabel('y(m)');
    legend([h1 h2 h3], '\color{green}Elbow', '\color{red}End Effector', '\color{white}Origin');
    
    

    
    
    
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WEIGHT SETS %%%%%%%%%%%%%%%%%%%%%%
% Experiment 01
% W1 =[2.248690002	2.822497933	-2.027790419;
%      2.473510282	1.33209164	-0.513514965;
%      -1.492164983	3.296538718	2.171090162];
% 
% 
% W2 = [4.958165254	-7.07325167 -3.370519958;
%       -10.77668038	9.761467737	-5.906549121];
%   
%     
% Experiment 02
% 
% W1 = [-2.38874368	2.470897877	-3.677703445;
% 1.988400397	1.253765154	-1.231054473;
% -0.398583356	0.893160074	2.156348822;
% 0.737801308	-1.62543566	-0.508334175;
% -5.266284134	3.745106041	1.462347078;
% 1.119815175	5.326358048	-0.239108538;
% 4.771665432	-0.671068703	-3.747569044;
% -0.988131884	4.47438725	-1.64723606;
% -2.422726092	-3.351649132	-1.425321517;
% -0.780963492	-1.973266458	-0.831663061];
% 
% W2 = [1.460769711	-0.897308111	-0.925132186	0.936161442	-2.670742983	-6.391019805	-0.729957988	5.13032706	-1.711956484	1.435304079;
% -5.043287325	-3.67159171	-0.1571036	0.366966845	-1.195419052	0.461776633	-4.738377576	-1.71326037	-2.758774313	-1.8300088];
% 

% Experiment 04
% W1 = [1.937981774	3.397895103	0.254889129;
%     -3.173571744	-2.25012757	-1.847717773;
%     3.545960318	-0.820872663	-2.31513313;
%     4.582252733	2.894263707	1.987560697;
%     -6.225364383	4.370943964	1.21139869;
%     -0.892635176	3.51823597	-2.160640174;
% ];
% 
% W2 = [-7.434692479	-0.34298334	-1.828482956	1.546818326	-2.93342885	4.814579008;
%       0.981596053	-5.331339594	-6.546717905	-1.76842762	-0.656340772	-5.072041905];


    %Experiment 7
%     W1 = [  4.2905   -0.2082    4.8711;
%             0.1803    5.0397   -4.6728;
%             0.1819   -1.2883    0.5013;
%            -0.0945    7.6776   -2.3559;
%             0.6134    6.1041   -1.3475;
%             0.8403   -1.7255    1.5234;
%            -3.5035   -1.3717   -0.1123;
%             4.1387   -0.8496   -3.7265;
%            -4.9274    5.1901    1.1961;
%             0.7271   -0.3410    1.3186;
%       ];
%       W2 =  [-0.4845   1.6897   -1.3428    6.5183   -8.7811   -1.2960    1.3821   -0.8640   -2.6027    0.3619;
%               7.8589   -6.6864   -3.7084   -0.5195   -2.1508   -3.4137   -2.6959   -6.3278   -1.0736   -4.0182
%       ]; 

% Experiment 09
% W1 = [  2.6861    2.7797   -1.7417;	
%         2.3665    1.5088   -0.4842;		
%        -0.8454    3.5593    2.0606;
%      ]; 
% 
% 
% W2 = [ 5.2133   -7.9302   -3.3098;		
%        -11.0554   10.6156   -6.1936		
%      ];


% Test 12 Nh 18

% W1=[
%     0.7734  -10.8713    1.7258
%    -1.6007    0.6542   -1.1935
%    -3.7724    9.1342    1.2425
%     3.4403    7.9048    1.5738
%     1.6791    7.9474    0.3211
%     1.8158    1.1967   -2.2793
% 
% ];
%     
% W2aug=[-2.661258194	6.997060737	-2.008617928	6.202207994	-10.44637429	3.849312424	-2.333304337
% -0.668671164	-9.161780132	1.308790051	1.529748111	-1.503092261	-10.50882847	-1.004150316
% ];
% 



% Experiment 16

% 
% W1 = [  0.2428    0.3741    1.6593
%         3.1545   -0.0997   -1.8283
%         0.3435    7.4260    0.7717
%         1.7581   -2.8336    2.0466
%         1.8231    3.4851    1.1531
%         2.5592    4.9525   -0.2131
%     ];
% 
% W2aug = [   -1.0446    1.9696   -3.4948   -4.0261    3.4218   -3.5382  0.8039
%             -4.7994   -5.2465   -0.3688    5.0534    5.1463   -0.8900 -6.2049
%         ];





