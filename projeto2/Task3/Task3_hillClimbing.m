function [sol, averageDelay, Loads, linkEnergy] = Task3_hillClimbing(sol, nNodes, Links, T, D, sP, nSP, energy)
    nFlows = size(T,1);
    [Loads, linkEnergy] = calculateLinkLoads(nNodes, Links, T, D, sP, sol);
    [averageRoundTripDelay1, averageRoundTripDelay2] = calculateServiceDelays(sP, sol, D, nFlows1, nFlows2);

    averageDelay = max(averageRoundTripDelay1, averageRoundTripDelay2);

    improved = true;
    linkEnergy = energy;

    while improved
        bestNeighDelay = inf;
        for flow = 1:nFlows 
            for path = 1:nSP(flow) % Iterate over all possible neighbors
                if sol(flow) ~= path % Don't swap solution with itself
                    auxsol = sol;
                    auxsol(flow) = path;
                    [auxLoads, auxEnergy] = calculateLinkLoads(nNodes, Links, T, D, sP, auxsol);
                    [auxAverageRoundTripDelay1, auxAverageRoundTripDelay2] = calculateServiceDelays(sP, auxsol, D, nFlows1, nFlows2);
                    
                    auxAverageDelay = max(auxAverageRoundTripDelay1, auxAverageRoundTripDelay2);

                    if auxAverageDelay < bestNeighDelay
                        bestNeighDelay = auxAverageDelay;
                        LoadsBestNeigh = auxLoads;
                        fbest = flow;
                        pbest = path;
                        energyBestNeigh = auxEnergy;
                    end
                end
            end
        end
        if bestNeighDelay < averageDelay % Found a better neighbor, swap values
            averageDelay = bestNeighDelay;
            sol(fbest) = pbest;
            Loads = LoadsBestNeigh;
            linkEnergy = energyBestNeigh;
        else
            improved = false;
        end
    end
end
