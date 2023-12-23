function [sol, averageDelay, Loads, linkEnergy]= Task3_hillClimbing(sol, nNodes, Links, T, D, sP, nSP, energy)
    nFlows = size(T,1);
    [Loads, linkEnergy, roundTripDelays] = calculateLinkLoads(nNodes, Links, T, D, sP, sol);
    [averageDelay, ~] = calculateAverageRoundTripDelay(roundTripDelays, T);

    improved = true;
    linkEnergy = energy;

    while improved
        bestNeighDelay = inf;
        for flow = 1:nFlows 
            for path = 1:nSP(flow) % Iterate over all possible neighbors
                if sol(flow) ~= path % Don't swap solution with itself
                    auxsol = sol;
                    auxsol(flow) = path;
                    [auxLoads, auxEnergy, auxRoundTripDelays] = calculateLinkLoads(nNodes, Links, T, D, sP, auxsol);
                    [auxAverageDelay, ~] = calculateAverageRoundTripDelay(auxRoundTripDelays, T);
                    
                    % check if the neighbor's delay is better than the current delay
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

function [averageDelay, roundTripDelays] = calculateAverageRoundTripDelay(roundTripDelays, T)
    nFlows1 = size(T,1); % Adjust according to your data structure
    nFlows2 = size(T,2); % Adjust according to your data structure
    
    totalDelay1 = sum(roundTripDelays(1:nFlows1));
    totalDelay2 = sum(roundTripDelays(nFlows1+1:end));
    averageDelay1 = totalDelay1 / nFlows1;
    averageDelay2 = totalDelay2 / nFlows2;
    
    averageDelay = max(averageDelay1, averageDelay2); % Prioritize the service with the worst delay
end

