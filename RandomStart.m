%% Random Starting State Code
% Build a vector containing all of the grid points
% Remove the illegal blocked off grids
% Randomly select from the resultant vector

% Adjust for x and y co-ordinates

function s0 = RandomStart(resultingState)
    blockedLocations = [5 1; 9 1; 2 2; 3 2; 3 3; 4 3; 6 3; 9 3; 1 4; 4 4; 9 4;7 5; 9 5; 3 6; 5 6; 7 6; 9 6; 2 7; 3 7; 7 7; 9 7; 3 8; 7 8; 7 9; resultingState];
    BlockedFlag = 0;

    for i = 1 : 10
        X(i) = i;
        Y(i) = i;
    end
    
    randomX = randi([1 10]);                         % Select a random row

    [blkdm,blkdn] = size(blockedLocations);          % Get the dimensions of the BlockedCells

    % Search for all of the blocked elements in that row
    idx = 1;
    for i = 1 : blkdm
        if ((blockedLocations(i,1) == randomX))
            BlockedFlag = 1;                         % Enable the blocked flag
            blockedColumns(idx) = blockedLocations(i,2);
            idx = idx + 1;
        end 
    end
    
 if (BlockedFlag == 1)                               % Only enter if there are blocked states in the row selected      
    [cm,cn] = size(blockedColumns);                  % Get the dimensions of the BlockedCells

    % Remove the blocked states from the possible starting points
    for i = 1 : cn                                   % Loop for the number of elements in the blocked array
        idx = find(Y == blockedColumns(i));          % Returns the index of the element from the blocked array  
        Y(idx) = [];                                 % Remove the sample from the vector
    end 
 end  
    s0 = [randomX Y(randi(numel(Y)))];               %Pick from the resultant vector with a uniform probability, numel = Number of array elements
end
