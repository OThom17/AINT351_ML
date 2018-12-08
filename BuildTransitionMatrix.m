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
        
