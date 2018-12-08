function s0Histogram
    endLocation = [6 6];
    for i = 1 : 1000
        s0(i,:) = RandomStart(endLocation);
        hists0(i) = ((s0(i,2)-1)*10 + s0(i,1));
    end
    %Visualise
    bins = 100;
    figure;
    hold on;
    histogram(hists0, bins);
    title('ISH: Histogram test of starting states');
    xlabel('Bins(100)');
    ylabel('Frequency');
    set(gca,'xtick',[1:2:101])
    hold off;

end