function [QValues, Count] = QTrial(QValues,s, Goal, gamma, alpha, expRate,tm)
    for i = 1 : 1000
       [QValues,Steps] = QEpisode(QValues,s, Goal, gamma, alpha, expRate, tm);
       Count(i) = Steps;
    end
end