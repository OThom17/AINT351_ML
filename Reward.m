%% Copied into CMazeMaze

function r = Reward(state, action)
    if (((state == 90) && (action == 1)) || ((state == 99) && (action == 2)))
        r = 10;
    else
        r = 0;
    end 
end 