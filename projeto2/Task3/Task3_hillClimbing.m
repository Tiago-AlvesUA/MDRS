function [sol,minDelay,linkEnergy]= Task3_hillClimbing(sol,nNodes,Links,T,L,sP,nSP,energy)
    nFlows = size(T,1);
    improved = true;
    linkEnergy = energy;
    minDelay = inf;
    while improved
        bestNeighDelay = inf;
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [auxDelays,auxEnergy]= Task3_calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    auxDelay = calculateAverageDelay(auxDelays);
                    
                    % check if the neighbour load is better than the
                    % current load
                    if auxDelay < bestNeighDelay
                        bestNeighDelay = auxDelay;
                        fbest = flow;
                        pbest = path;
                        energyBestNeigh= auxEnergy;
                    end
                end
            end
        end
        if bestNeighDelay < minDelay 
            minDelay = bestNeighDelay;
            sol(fbest)= pbest;
            linkEnergy = energyBestNeigh;
        else
            improved = false;
        end
    end
end

function averageDelay = calculateAverageDelay(Delays)
    totalDelay = sum(Delays(:, 3));
    numberOfDelays = size(Delays, 1);
    averageDelay = totalDelay / numberOfDelays;
end
