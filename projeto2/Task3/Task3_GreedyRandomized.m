function [sol, averageDelay, linkEnergy] = Task3_GreedyRandomized(nNodes, Links, T, D, sP, nSP, sol)
    nFlows = size(T,1);
    averageDelay = inf;

    for flow= randperm(nFlows) % random order of flows
        path_index = 0;
        best_delay = inf;
        best_energy = inf;

        for path = 1 : nSP(flow)
            sol(flow) = path;
            [Loads, linkEnergy] = calculateLinkLoads(nNodes, Links, T, D, sP, sol);
            [averageRoundTripDelay1, averageRoundTripDelay2] = calculateServiceDelays(sP, sol, D, nFlows1, nFlows2);

            maxDelay = max(averageRoundTripDelay1, averageRoundTripDelay2);

            if maxDelay < best_delay % if delay obtained is lesser than previously obtained best, swap
                path_index = path;
                best_delay = maxDelay;
                best_energy = linkEnergy;
            end
        end
        sol(flow) = path_index;
        averageDelay = best_delay;
    end
    linkEnergy = best_energy;
end
