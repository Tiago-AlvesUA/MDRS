function [sol,worstDelay,otherDelay,load,linkEnergy] = Task3_GreedyRandomized_Otim_Delay(worst, nNodes,Links,T, ...
    D,sP,nSP,sol, nFlowsX, L)
    nFlows = size(T,1);

    for flow= randperm(nFlows) % ordem random dos fluxos
        path_index = 0;
        bestWorstDelay = inf;
        bestOtherDelay = inf;
        for path = 1 : nSP(flow)
            sol(flow) = path;
            % fprintf('\naaaHHHHHHH sol(flow) = path; 1 %.4f', sol(flow));
            [worstDelay, otherDelay, ~] = calculateServiceDelays(sP, sol, D, nFlowsX, nFlows - nFlowsX);

            [Loads,linkEnergy] = calculateLinkLoads(nNodes, Links, T,L, sP, sol);
            maxLoad = max(max(Loads(:,3:4)));

            if worstDelay < bestWorstDelay && worst
                path_index = path;
                best_load = maxLoad;
                best_energy = linkEnergy;

                bestWorstDelay = worstDelay;
            end
            if otherDelay < bestOtherDelay && ~worst
                path_index = path;
                best_load = maxLoad;
                best_energy = linkEnergy;

                bestOtherDelay = otherDelay;
            end
        end
        sol(flow) = path_index;
    end
    load = best_load;
    linkEnergy = best_energy;

    worstDelay = bestWorstDelay;
    otherDelay = bestOtherDelay;
end