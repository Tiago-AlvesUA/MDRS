function [sol,load,Loads]= hillClimbing(sol,nNodes,Links,T,sP,nSP)
    nFlows = size(T,1);
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    improved = true;
    while improved
        loadBestNeigh= inf;
        for flow= 1:nFlows 
            for path= 1:nSP(flow) %Rodar por todos os vizinhos possiveis
                if sol(flow)~=path %Não trocar a sol por ela mesma
                    auxsol = sol;
                    auxsol(flow)= path;
                    auxLoads= calculateLinkLoads(nNodes,Links,T,sP,auxsol);
                    auxload= max(max(auxLoads(:,3:4)));
                    % check if the neighbour load is better than the
                    % current load
                    if auxload<loadBestNeigh
                        loadBestNeigh= auxload;
                        LoadsBestNeigh= auxLoads;
                        fbest = flow;
                        pbest = path;
                    end
                end
            end
        end
        if loadBestNeigh<load % Encontrado melhor vizinho, trocar valores
            load= loadBestNeigh;
            sol(fbest)= pbest;
            Loads= LoadsBestNeigh;
        else
            improved = false;
        end
    end
end
