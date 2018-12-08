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


classdef CMazeMaze10x10
    % define Maze work for RL
    %  Detailed explanation goes here
    
    properties
        
        % parameters for the gmaze grid management
        %scalingXY;
        blockedLocations;
        cursorCentre;
        limitsXY;
        xStateCnt
        yStateCnt;
        stateCnt;
        stateNumber;
        totalStateCnt
        squareSizeX;
        cursorSizeX;
        squareSizeY;
        cursorSizeY;
        stateOpen;
        stateStart;
        stateEnd;
        stateEndID;
        stateX;
        stateY;
        xS;
        yS
        stateLowerPoint;
        textLowerPoint;
        stateName;
        positionFigure;
        
        % parameters for Q learning
        QValues;
        tm;
        actionCnt;
    end
    
    methods
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % constructor to specity maze
        function f = CMazeMaze10x10(limitsXY)
            
            % set scaling for display
            f.limitsXY = limitsXY;
            f.blockedLocations = [];
            
            % setup actions
            f.actionCnt = 4;
            
            % build the maze
            f = SimpleMaze10x10(f);
            
            % display progress
            disp(sprintf('Building Maze CMazeMaze10x10'));
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % build the maze
        function f = SetMaze(f, xStateCnt, yStateCnt, blockedLocations, startLocation, endLocation)
            
            % set size
            f.xStateCnt=xStateCnt;
            f.yStateCnt=yStateCnt;
            f.stateCnt = xStateCnt*yStateCnt;
            
            % compute state countID
            for x =  1:xStateCnt
                for y =  1:yStateCnt
                    
                    % get the unique state identified index
                    ID = x + (y -1) * xStateCnt;
                    
                    % record it
                    f.stateNumber(x,y) = ID;
                    
                    % also record how x and y relate to the ID
                    f.stateX(ID) = x;
                    f.stateY(ID) = y;
                end
            end
            
            % calculate maximum number of states in maze
            % but not all will be occupied
            f.totalStateCnt = f.xStateCnt * f.yStateCnt;
            
            
            % get cell centres
            f.squareSizeX= 1 * (f.limitsXY(1,2) - f.limitsXY(1,1))/f.xStateCnt;
            f.cursorSizeX = 0.5 * (f.limitsXY(1,2) - f.limitsXY(1,1))/f.xStateCnt;
            f.squareSizeY= 1 * (f.limitsXY(2,2) - f.limitsXY(2,1))/f.yStateCnt;
            f.cursorSizeY = 0.5 * (f.limitsXY(2,2) - f.limitsXY(2,1))/f.yStateCnt;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % init maze with no closed cell
            f.stateOpen = ones(xStateCnt, yStateCnt);
            f.stateStart = startLocation;
            f.stateEnd = endLocation;
            f.stateEndID = f.stateNumber(f.stateEnd(1),f.stateEnd(2));
            
            % put in blocked locations
            for idx = 1:size(blockedLocations,1)
                bx = blockedLocations(idx,1);
                by = blockedLocations(idx,2);
                f.stateOpen(bx, by) = 0;
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % get locations for all states
            for x=1:xStateCnt
                for y=1:xStateCnt
                    
                    % start at (0,0)
                    xV = x-1;
                    yV = y-1;
                    
                    % pure scaling component
                    % assumes input is between 0 - 1
                    scaleX =  (f.limitsXY(1,2) - f.limitsXY(1,1)) / xStateCnt;
                    scaleY = (f.limitsXY(2,2) - f.limitsXY(2,1)) / yStateCnt;
                    
                    % remap the coordinates and add on the specified orgin
                    f.xS(x) = xV  * scaleX + f.limitsXY(1,1);
                    f.yS(y) = yV  * scaleY + f.limitsXY(2,1);
                    
                    % remap the coordinates, add on the specified orgin and add on half cursor size
                    f.cursorCentre(x,y,1) = xV * scaleX + f.limitsXY(1,1) + f.cursorSizeX/2;
                    f.cursorCentre(x,y,2) = yV * scaleY + f.limitsXY(2,1) + f.cursorSizeY/2;
                    
                    f.stateLowerPoint(x,y,1) = xV * scaleX + f.limitsXY(1,1);  - f.squareSizeX/2;
                    f.stateLowerPoint(x,y,2) = yV * scaleY + f.limitsXY(2,1); - f.squareSizeY/2;
                    
                    f.textLowerPoint(x,y,1) = xV * scaleX + f.limitsXY(1,1)+ 10 * f.cursorSizeX/20;
                    f.textLowerPoint(x,y,2) = yV * scaleY + f.limitsXY(2,1) + 10 * f.cursorSizeY/20;
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % draw rectangle
        function DrawSquare( f, pos, faceColour)
            % Draw rectagle
            rectangle('Position', pos,'FaceColor', faceColour,'EdgeColor','k', 'LineWidth', 3);
        end
        
        % draw circle
        function DrawCircle( f, pos, faceColour)
            % Draw rectagle
            rectangle('Position', pos,'FaceColor', faceColour,'Curvature', [1 1],'EdgeColor','k', 'LineWidth', 3);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % draw the maze
        function DrawMaze(f)
            figure('position',[100, 100, 1500/2, 1500/2]);
            set(gca,'color','k');
            set(gca,'xtick',[-1:0.1:0.5]);
            set(gca,'ytick',[-0.3:0.1:1]);
            ylim([-0.4 1])
            xlim([-1.1 0.5])
            fontSize = 20;
            hold on
            h=title(sprintf('ISH: Maze wth %d x-axis X %d y-axis cells', f.xStateCnt, f.yStateCnt));
            set(h,'FontSize', fontSize);
            
            for x=1:f.xStateCnt
                for y=1:f.yStateCnt
                    pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                    % if location open plot as blue
                    if(f.stateOpen(x,y))
                        DrawSquare( f, pos, 'b');
                        % otherwise plot as black
                    else
                        DrawSquare( f, pos, 'k');
                    end
                end
            end
            
            
            % put in start locations
            for idx = 1:size(f.stateStart,1)
                % plot start
                x = f.stateStart(idx, 1);
                y = f.stateStart(idx, 2);
                pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                DrawSquare(f, pos,'g');
            end
            
            % put in end locations
            for idx = 1:size(f.stateEnd,1)
                % plot end
                x = f.stateEnd(idx, 1);
                y = f.stateEnd(idx, 2);
                pos = [f.stateLowerPoint(x,y,1)  f.stateLowerPoint(x,y,2)  f.squareSizeX f.squareSizeY];
                DrawSquare(f, pos,'r');
            end
            
            %put on names
            for x=1:f.xStateCnt
                for y=1:f.yStateCnt
                    sidx=f.stateNumber(x,y);
                    stateNameID = sprintf('%s', f.stateName{sidx});
                    text(f.textLowerPoint(x,y,1),f.textLowerPoint(x,y,2), stateNameID, 'FontSize', 6)
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % setup 10x10 maze
        function f = SimpleMaze10x10(f)
            
            xCnt=10;
            yCnt=10;
            
            % specify end location in (x,y) coordinates
            % example only
            endLocation=[10 10];            % NEED TO RANDOMISE AT SOMEPOINT

            % specify blocked location in (x,y) coordinates
            f.blockedLocations = [5 1; 9 1; 2 2; 3 2; 3 3; 4 3; 6 3; 9 3; 1 4; 4 4; 9 4;7 5; 9 5; 3 6; 5 6; 7 6; 9 6; 2 7; 3 7; 7 7; 9 7; 3 8; 7 8; 7 9];
                    
            % specify start location in (x,y) coordinates
            %startLocation = RandomStatingState(f);
            startLocation = [1 1]
            
            % build the maze
            f = SetMaze(f, xCnt, yCnt, f.blockedLocations, startLocation, endLocation);
            
            % write the maze state
            maxCnt = xCnt * yCnt;
            for idx = 1:maxCnt
                f.stateName{idx} = num2str(idx);
            end    
        end
        

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPLETE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % reward function that takes a stateID and an action
        function reward = RewardFunction(f, stateID, action)
            if (((stateID == 90) && (action == 1)) || ((stateID == 99) && (action == 2)))
                reward = 10;
            else
                reward = 0;
            end 
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% COMPLETE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function  computes a random starting state
        function startingState = RandomStatingState(f)
            blockedL = [f.blockedLocations; 10 10];        % Add the end location
            BlockedFlag = 0;
            randomX = randi([1 10]);                          % Select a random row
            [blkdm,~] = size(f.blockedLocations);             % Get the dimensions of the BlockedCells
            % Search for all of the blocked elements in that row
            idx = 1;
            for i = 1 : blkdm
                if ((blockedL(i,1) == randomX))
                    BlockedFlag = 1;                         % Enable the blocked flag
                    blockedColumns(idx) = blockedL(i,2);
                    idx = idx + 1;
                end 
            end
         for i = 1 : 10
             Y(i) = i;                                       % Generate a vector of possible column references (Y-Vals)
         end
         if (BlockedFlag == 1)                               % Only enter if there are blocked states in the row selected      
            [~,cn] = size(blockedColumns);                   % Get the dimensions of the BlockedCells
            % Remove the blocked states from the possible starting points
            for i = 1 : cn                                   % Loop for the number of elements in the blocked array
                idx = find(Y == blockedColumns(i));          % Returns the index of the element from the blocked array  
                Y(idx) = [];                                 % Remove the sample from the vector
            end 
         end  
            startingState = [randomX Y(randi(numel(Y)))];    % Pick from the resultant vector with a uniform probability, numel = Number of array elements
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% COMPLETE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % look for end state
        function endState = IsEndState(f, x, y)
            
            % default to not found
            endState=0;
            
            % YOUR CODE GOES HERE ....
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPLETE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % init the q-table
        function f = InitQTable(f, minVal, maxVal)     
            % allocate
            f.QValues = zeros(f.xStateCnt * f.yStateCnt, f.actionCnt);
            f.QValues =  0.01 * randi([(minVal*100) (maxVal*100)], f.xStateCnt*f.yStateCnt, f.actionCnt);    % Initialise with values ranging from 0.1 to 0.01
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPLETE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % build the transition matrix
        % look for boundaries on the grid
        % also look for blocked state
        function f = BuildTransitionMatrix(f)
            % Initialise
            f.tm = zeros(f.xStateCnt * f.yStateCnt, f.actionCnt);
            % Cycle through the grid
            for x = 1 : f.xStateCnt
                for y = 1 : f.yStateCnt
                    StateID = f.stateNumber(x,y); % Convert to a state ID
                    initmatched = CheckblockedLocations([x y]);
                    if (initmatched == 0)
                        for k = 1 : f.actionCnt
                            if    (k == 1)
                                f.tm(StateID,k) = CheckState([x y],[x (y+1)]);
                            elseif(k == 2)
                                f.tm(StateID,k) = CheckState([x y],[(x+1) y]);                       
                            elseif(k == 3)
                                f.tm(StateID,k) = CheckState([x y],[x (y-1)]);                           
                            elseif(k == 4)
                                f.tm(StateID,k) = CheckState([x y],[(x-1) y]);                        
                            end
                        end 
                    else
                        f.tm(StateID,:) = [0 0 0 0];    % Block off the blocked states as they'll never be entered (Error catching perhaps)
                    end
                end 
            end 
            function matched = CheckblockedLocations(Coord) % General function to see if the co-ordinate is in the blocked list
                   match = ismember(f.blockedLocations, Coord, 'rows');
                   matched = 0;
                   [m,~] = size(f.blockedLocations);
                   for idx = 1 : m
                       if (match(idx) == 1)
                           matched = 1;
                       end
                   end                
            end
            function sprime = CheckState(CurrentCoord, NextCoord)
                % Boundary Condition Check first
                if ((NextCoord(1) > 10) || (NextCoord(1) < 1)) 
                    sprimeCoord = CurrentCoord;
                elseif ((NextCoord(2) > 10) || (NextCoord(2) < 1))
                    sprimeCoord = CurrentCoord;
                else 
                    %Blocked State Condition next
                    matched = CheckblockedLocations(NextCoord);
                    if (matched == 1)        
                        sprimeCoord = CurrentCoord;
                    else
                        sprimeCoord = NextCoord;
                    end
                end
                sprime = f.stateNumber(sprimeCoord(1),sprimeCoord(2)); % Convert to a state ID
            end 
        end     
    end
end

