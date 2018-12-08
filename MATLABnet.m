function MATLABnet
    HiddenUnits = 3;
    
    net1 = feedforwardnet(HiddenUnits);
    [theta, endpoints] = DisplayWorkspace(1000);
    trainingData = theta;
    trainingTarget1 = endpoints;
    net1 = configure(net1, trainingData, trainingTarget1);
    net1 = train(net1, trainingData, trainingTarget1);

end