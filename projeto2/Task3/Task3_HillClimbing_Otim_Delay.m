function [sol, load]= Task3_HillClimbing_Otim_Delay(sol, nNodes, ...
    Links,T,D,sP,nSP,L,nFlows1)
    nFlows = size(T,1);
        
    T1_idx = 1:nFlows1;
    T2_idx = 1+nFlows1:nFlows;

    energyBestNeigh = inf;
    LoadsBestNeigh = inf;
    bestDelay = calculateServiceDelays(sP, sol, D, T);
    % disp(['auxDelay: ', bestDelay]);
    bestSol = sol;    
    
    improved = true;
    while improved
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    [auxLoads,auxLinkEnergy]= calculateLinkLoads(nNodes,Links,T,L,sP,auxsol);
                    % delay of this sol
                    auxDelay = calculateServiceDelays(sP, auxsol, D, T);
                    %priorities
                    % disp(['auxDelay: ', auxDelay]);
                    % disp(['Size of auxDelay: ', num2str(length(auxDelay))]);
                    % disp(['T1_idx range: ', num2str(min(T1_idx)), ' - ', num2str(max(T1_idx))]);
                    % disp(['T2_idx range: ', num2str(min(T2_idx)), ' - ', num2str(max(T2_idx))]);

                    p_auxRoundTripDelay = sum(auxDelay(T1_idx)) + 0.5 * sum(auxDelay(T2_idx));
                    p_bestRoundTripDelay = sum(auxDelay(T1_idx)) + 0.5 * sum(auxDelay(T2_idx));
                    
                    if p_auxRoundTripDelay < p_bestRoundTripDelay
                        energyBestNeigh = auxLinkEnergy;
                        LoadsBestNeigh = auxLoads;
                        bestSol = auxsol;
                        bestDelay = auxDelay;
                    end
                end
            end
        end
        if max(bestDelay(T1_idx)) < calculateServiceDelays(sP, sol, D, T) % Encontrado melhor vizinho, trocar valores
            % delay = bestDelay;
            % energy = energyBestNeigh;
            % Loads = LoadsBestNeigh;
            sol = bestSol;
            load = max(bestDelay(T1_idx));
            if Loads == inf
                load = inf;
            end
        else
            load = max(calculateServiceDelays(sP, sol, D, T));
            improved = false;
        end
    end
end
