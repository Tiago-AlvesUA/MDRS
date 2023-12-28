function [sol, load,Loads,linkEnergy, delay]= Task3_HillClimbing_Otim_Delay(sol, nNodes,Links,T,D,sP,nSP,L,nFlows1,linkEnergy)
    nFlows = size(T,1);
        
    T1_idx = 1:nFlows1;
    T2_idx = 1+nFlows1:nFlows;

    Loads= calculateLinkLoads(nNodes,Links,T,L,sP,sol);
    load= max(max(Loads(:,3:4)));

    % delay calculado com sol do greedy, de todos os fluxos/serviços
    bestDelay = calculateServiceDelays(sP, sol, D, T);
    delay = (sum(calculateServiceDelays(sP, sol, D, T)))/20;
    %display(delay);
    improved = true;
    while improved
        loadBestNeigh = inf;
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [auxLoads,auxLinkEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    auxload= max(max(auxLoads(:,3:4)));
                    
                    % delay of this sol
                    auxDelay = calculateServiceDelays(sP, auxsol, D, T);

                    % 0.5 * T2, porque T1 é mais obrigatoria
                    valueAuxDelay = (sum(auxDelay(T1_idx)) + 0.5 * sum(auxDelay(T2_idx)))/20;
                    valueBestDelay = (sum(bestDelay(T1_idx)) + 0.5 * sum(bestDelay(T2_idx)))/20;

                    if valueAuxDelay < valueBestDelay
                        loadBestNeigh = auxload;
                        energyBestNeigh = auxLinkEnergy;
                        LoadsBestNeigh = auxLoads;
                        bestSol = auxsol;
                        bestDelay = auxDelay;
                    end
                end
            end
        end
        if max(bestDelay(T1_idx)) < delay % Encontrado melhor vizinho, trocar valores
            load = loadBestNeigh;
            Loads = LoadsBestNeigh;
            linkEnergy = energyBestNeigh;
            sol = bestSol;
            delay = max(bestNeighDelay(T1_idx));
            
            
%             if Loads == inf
%                 load = inf;
%             end
        else
            improved = false;
        end
    end
end
