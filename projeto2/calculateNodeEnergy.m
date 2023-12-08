function nodesEnergy = calculateNodeEnergy(T,sP,Solution)
    nFlows= size(T,1);
    nodesEnergy = 0;
    for i= 1:nFlows
        if Solution(i)>0
            path= sP{i}{Solution(i)};
            totalTT = sum(T(i,3:4)); %total throughput traffic supported by the router 
            for node=1:path
                nodesEnergy = nodesEnergy + (20 + 80 * sqrt(totalTT/1000));
            end
        end
    end
end

