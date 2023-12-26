function [sol,worstDelay, otherDelay,load,Loads,linkEnergy]= Task3_HillClimbing_Otim_Delay(worst, sol, nNodes, ...
    Links,T,D,sP,nSP,nFlows1,worstDelay,otherDelay,energy,L)
    nFlows = size(T,1);
    
    Loads= calculateLinkLoads(nNodes,Links,T,L,sP,sol);
    load= max(max(Loads(:,3:4)));
    linkEnergy = energy;
    
    improved = true;
    while improved
        bestWorstDelay = inf;
        bestOtherDelay = inf;

        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [worstDelay, otherDelay, ~] = calculateServiceDelays(sP, auxsol, D, nFlows1, nFlows - nFlows1);
                    
                    [auxLoads,auxEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    auxload= max(max(auxLoads(:,3:4)));

                    % check if the neighbour load is better than the
                    % current load
                    if worstDelay < bestWorstDelay && worst
                        bestWorstDelay = worstDelay;
                        fbest = flow;
                        pbest = path;

                        loadBestNeigh= auxload;
                        LoadsBestNeigh= auxLoads;
                        energyBestNeigh= auxEnergy;
                    end
                    if otherDelay < bestOtherDelay && ~worst
                        bestOtherDelay = otherDelay;
                        fbest = flow;
                        pbest = path;

                        loadBestNeigh= auxload;
                        LoadsBestNeigh= auxLoads;
                        energyBestNeigh= auxEnergy;
                    end
                end
            end
        end
        if bestWorstDelay < worstDelay && worst % Encontrado melhor vizinho, trocar valores
            worstDelay = bestWorstDelay;
            sol(fbest)= pbest;

            load= loadBestNeigh;
            Loads= LoadsBestNeigh;
            linkEnergy = energyBestNeigh;
        end
        if bestOtherDelay < otherDelay && ~worst
            otherDelay = bestOtherDelay;
            sol(fbest)= pbest;

            load= loadBestNeigh;
            Loads= LoadsBestNeigh;
            linkEnergy = energyBestNeigh;
        else
            improved = false;
        end
    end
end
