function [QValues, step_count] = QEpisode(QValues,s, Goal, gamma, alpha, expRate, tm)
    step_count = 1; % Track the number of steps taken to solve the maze

    %Repeat each episode
    while s ~= Goal

        %e-greedy
        a = Action_Select(QValues, s, expRate); % Okay up to here

        %Take Action
        sprime = tm(s, a);

        %Observe Reward
        r = Reward(s, a);

        %Update Q_Table
        QValues(s,a) = QValues(s,a) + alpha*(r + (gamma * (max(QValues(sprime,:)))) - QValues(s,a));

        %Assign sprime to s
        s = sprime;

        State_History(step_count) = s;
        step_count = step_count + 1;
        
    end
end