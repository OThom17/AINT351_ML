function QValues = QExperiment(QValues,s, goal, gamma, alpha, expRate, tm)
    for i = 1 : 100
        [QValues, Steps] = QTrial(QValues,s, goal, gamma, alpha, expRate, tm);
        Count(i,:) = Steps;
    end 

%        
%     %Mean and Std. Deviation Plot
%     [m, n] = size(Count);
%     for idx = 1 : n
%         Mean(idx) = mean(Count(:,idx));
%         stdD(idx) = std(Count(:,idx));
%     end 
%     figure;
%     hold on;
%     title('Mean and Std. Dev. of Q-Learning Steps');
%     ylabel('Steps');
%     xlabel('Q-Learning Interval Step');
%     errorbar(Mean,stdD)
%     plot(Mean);
%     hold off;
    
end
