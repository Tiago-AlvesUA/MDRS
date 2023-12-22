function [sol,load,Loads,linkEnergy]= Task2a_hillClimbing_EnergyOptimized(sol,nNodes,Links,T,L,sP,nSP,energy)
    nFlows = size(T,1);
    Loads= calculateLinkLoads(nNodes,Links,T,L,sP,sol);
    load= max(max(Loads(:,3:4)));
    improved = true;
    linkEnergy = energy;
    while improved
        energyBestNeigh = inf;
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [auxLoads,auxEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    auxload= max(max(auxLoads(:,3:4)));
                    % check if the neighbour load is better than the
                    % current load
                    if auxEnergy<energyBestNeigh
                        loadBestNeigh= auxload;
                        LoadsBestNeigh= auxLoads;
                        fbest = flow;
                        pbest = path;
                        energyBestNeigh= auxEnergy;
                    end
                end
            end
        end
        if energyBestNeigh<linkEnergy % Encontrado melhor vizinho, trocar valores
            load= loadBestNeigh;
            sol(fbest)= pbest;
            Loads= LoadsBestNeigh;
            linkEnergy = energyBestNeigh;
        else
            improved = false;
        end
    end
end