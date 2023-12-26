clear all;
close all;
clc;

load('InputDataProject2.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
T_Unicast=[T1;T2];
nFlowsUnicast= size(T_Unicast,1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);
nFlowsAnycast= size(T3,1);

% Matriz D -> atraso de propagacao
D = L/(2*10^5); % L -> Matriz com comprimento de todas ligacoes

anycastPairs = nchoosek(1:15,2);


%% 4 c)
% Computing up to k=6 shortest paths for all flows:
k= 6;
sP_Unicast= cell(1,nFlowsUnicast);
nSP_Unicast= zeros(1,nFlowsUnicast);
for f=1:nFlowsUnicast
    [shortestPath, totalCost] = kShortestPath(D,T_Unicast(f,1),T_Unicast(f,2),k);
    sP_Unicast{f}= shortestPath;
    nSP_Unicast(f)= length(totalCost);
end

bestRoundTripDelay = inf;
bestPair = [0 0];
for pair = 1:size(anycastPairs,1)
    anycastNodes = anycastPairs(pair,:);
    fprintf("pair: %d,%d \n", anycastNodes(1), anycastNodes(2));
    [sP_Anycast,nSP_Anycast]= bestCostPaths(nNodes,anycastNodes,D,T3);

    % Pair that minimizes average round trip delay of the anycast service
    roundTripDelays = zeros(1,nFlowsAnycast);
    for f = 1:nFlowsAnycast   
        path= sP_Anycast{f}{1}; 
        total_delay = 0;
        for j=2:length(path)
            propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
            total_delay = total_delay + propagation_delay;
        end
        roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
    end
    totalRoundTripDelay = sum(roundTripDelays);
    averageRoundTripDelay = totalRoundTripDelay / nFlowsAnycast;

    fprintf("avg round-trip delay: %f\n\n",averageRoundTripDelay);

    if averageRoundTripDelay < bestRoundTripDelay
        bestRoundTripDelay = averageRoundTripDelay;
        bestPair = anycastNodes;
    end
end

fprintf("Melhor par: %d,%d\n",bestPair(1),bestPair(2));














%%
% bestAvgRoundTripDelay = inf;
% contador = 0;
% somador = 0;
% for pair = 1:size(anycastPairs,1)
%     anycastNodes = anycastPairs(pair,:);
%     [sP_Anycast,nSP_Anycast]= bestCostPaths(nNodes,anycastNodes,D,T3);
%     
%     % VERFICAR SE OS sP OBTIDOS SÃO OS MELHORES EM TERMOS DE ROUND TRIP
%     % PROPAGATION DELAY
%     % Se sim, guardar os sP
% 
% 
%     % Add destination nodes no anycast matrix T3
%     T3_any = [T3(:,1) zeros(size(T3,1),1) T3(:,2:3)];
%     for i= 1:size(T3,1)
%         T3_any(i,2) = sP_Anycast{i}{1}(end);
%     end
%     
%     % Concatenate unicast and anycast T's, sP's and nSP's
%     T = [T_Unicast; T3_any];
%     sP = cat(2, sP_Unicast, sP_Anycast);
%     nSP = cat(2, nSP_Unicast, nSP_Anycast);
%     
%     nFlows = size(T,1);
%     
%     t = tic;
%     timeLimit = 60; % runtime limit of 60 seconds
%     while toc(t) < timeLimit
%         sol = zeros(1, nFlows);
%     
%         % TODO - Change L matrix for D? (Propagation delay)
%         [sol, Loads, totalEnergy] = Task4_GreedyRandomized_EnergyOptimized(nNodes, Links, T, L, sP, nSP, sol);
%     
%         [sol, load, Loads, totalEnergy] = Task4_hillClimbing_EnergyOptimized(sol, nNodes, Links, T, L, sP, nSP, totalEnergy, Loads);
%         
%         roundTripDelays = zeros(1,nFlowsAnycast);
%         for f = 21:nFlowsAnycast+nFlowsUnicast
%             if sol(f) ~= 0
%                 path= sP{f}{sol(f)}; % Para cada fluxo vamos buscar o caminho solucao
%                 total_delay = 0;
%                 for j=2:length(path)
%                     propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
%                     total_delay = total_delay + propagation_delay;
%                 end
%                 roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
%             end
%         end
%         totalRoundTripDelay = sum(roundTripDelays);
%         averageRoundTripDelay3 = totalRoundTripDelay / nFlowsAnycast;
% 
%         if averageRoundTripDelay3 < bestAvgRoundTripDelay
%             bestSol = sol;
%             bestLoad = load;
%             bestLoads = Loads;
%             bestEnergy = totalEnergy;
%             bestAvgRoundTripDelay = averageRoundTripDelay3;
%             bestTime = toc(t);
%         end
%         contador = contador + 1;
%         somador=somador+load;
%     end
% end
% 
% % Calculate round-trip propagation delay
% roundTripDelays = zeros(1,nFlows1);
% for f = 1:nFlows1   
%     if bestSol(f) ~= 0
%         path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
%         total_delay = 0;
%         for j=2:length(path)
%             propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
%             total_delay = total_delay + propagation_delay;
%         end
%         roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
%     end
% end
% totalRoundTripDelay = sum(roundTripDelays);
% averageRoundTripDelay1 = totalRoundTripDelay / nFlows1;
% 
% roundTripDelays = zeros(1,nFlows2);
% for f = 13:nFlows2+12
%     if bestSol(f) ~= 0
%         path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
%         total_delay = 0;
%         for j=2:length(path)
%             propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
%             total_delay = total_delay + propagation_delay;
%         end
%         roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
%     end
% end
% totalRoundTripDelay = sum(roundTripDelays);
% averageRoundTripDelay2 = totalRoundTripDelay / nFlows2;
% 
% % Calculate average Link Load
% link_load_sum = sum(Loads(:, 3)) + sum(Loads(:, 4));
% avgLinkLoadSol = link_load_sum / (2 * nLinks);
% worstLinkLoad = max(max(Loads(:, 3:4)));
% 
% % Calculate links not supporting any traffic flow
% linksNoTraffic = find(sum(Loads(:, 3:4), 2) == 0);
% 
% fprintf('Worst link load of the solution = %.2f Gbps\n', worstLinkLoad);
% fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol/2);
% fprintf('Total network energy consumption of the solution = %.2f\n', bestEnergy);
% fprintf('Average round-trip propagation delay of unicast service 1 = %f sec\n',averageRoundTripDelay1);
% fprintf('Average round-trip propagation delay of unicast service 2 = %f sec\n',averageRoundTripDelay2);
% fprintf('Average round-trip propagation delay of anycast service 3 = %f sec\n',bestAvgRoundTripDelay);
% fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
% fprintf('List of links not supporting any traffic flow:\n');
% for i = linksNoTraffic'
%     fprintf('\t%d -> %d\n', Loads(i, 1), Loads(i, 2));
% end
% fprintf('Number of cycles run by the algorithm = %d\n', contador);
% fprintf('Time obtained best solution = %f sec\n', bestTime);


