function [sol, minDelay,linkEnergy] = Task3_GreedyRandomized(nNodes,Links,T,L,sP,nSP,sol)
    nFlows = size(T,1);
    minDelay = inf;
    for flow= randperm(nFlows) % ordem random dos fluxos
        % path_index = 0;
        bestPath = sol(flow);
        best_energy = inf;
        bestPathDelay = inf;
        for path = 1 : nSP(flow)
            sol(flow) = path;
            [Delays,linkEnergy] = Task3_calculateLinkLoads(nNodes, Links, T,L, sP, sol);
            % maxLoad = max(max(Delays(:,3:4)));
            currentDelay = calculateAverageDelay(Delays);
            
            if currentDelay < bestPathDelay % se load obtida for menor a melhor obtida anteriormente, trocar
                bestPath = path;
                bestPathDelay = currentDelay;
                best_energy = linkEnergy;
            end
        end
        % sol(flow) = path_index;
    end
    sol(flow) = bestPath;
    minDelay = bestPathDelay;
    linkEnergy = best_energy;
end

function averageDelay = calculateAverageDelay(Delays)
    totalDelay = sum(Delays(:, 3));
    numberOfDelays = size(Delays, 1);
    averageDelay = totalDelay / numberOfDelays;
end
