%% Automatically generate a transition matrix
% Search for boundaries and blocked off states. Use the blockedLocations
% matrix and the maze edges.
% Cycle through each element from [1 1] to [10 10]
% Perform a N E S W action for each. If the new state is a blocked state
% then the new state is the current state.
% If the new state is beyond a boundary the new state is the current state
% blockedLocations known
% boundary detection - define a perimeter matrix

% if action == 1 N Y++
% if action == 2 E X++
% if action == 3 S Y--
% if action == 4 W X--

% f.stateNumber(x,y) = ID; Example ID conversion

function actionMatrix = Transition_Function_Legacy(xStateCnt, yStateCnt, actionCnt)
    actionMatrix = zeros(xStateCnt * yStateCnt, actionCnt);
    % Cycle through the grid
    for x = 1 : xStateCnt
        for y = 1 : yStateCnt
            StateID = f.stateNumber(x,y); % Convert to a state ID
            for k = 1 : actionCnt
                if    (k == 1)
                    actionMatrix(StateID,k) = CheckState([x y],[x (y+1)]);
                elseif(k == 2)
                    actionMatrix(StateID,k) = CheckState([x y],[(x+1) y]);                       
                elseif(k == 3)
                    actionMatrix(StateID,k) = CheckState([x y],[x (y-1)]);                           
                elseif(k == 4)
                    actionMatrix(StateID,k) = CheckState([x y],[(x-1) y]);                        
                end
                % Check blocked states and boundaries
            end 
        end 
    end 

    function sprime = CheckState(CurrentCoord, NextCoord)
        % Boundary Condition Check
        if ((NextCoord(1) > 10) || (NextCoord(1) < 1)) 
            sprimeCoord = CurrentCoord;
        elseif ((NextCoord(2) > 10) || (NextCoord(2) < 1))
            sprimeCoord = CurrentCoord;
        end 
        %Blocked State Condition
        if (any(f.blockedLocations(:) == sprimeCoord))        
            sprimeCoord = CurrentCoord;
        else
            sprimeCoord = NextCoord;
        end
        sprime = f.stateNumber(sprimeCoord(1),sprimeCoord(2)); % Convert to a state ID
    end 
end
