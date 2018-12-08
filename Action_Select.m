function Action = Action_Select(Q_Table, State, expRate)
%Epsilon Greedy Function 90% Highest Q Value and 10% random
%Select based upon the distribution
    Dist = rand(1,1);
    if (Dist < expRate)
    %Highest Q Value from across the state vector
        [~, Action] = max(Q_Table(State,:));  
    else
    %Random Action from Q_Table
        Action = randi([1 4]);
    end  
end

