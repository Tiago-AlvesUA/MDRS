clear all;
close all;
clc;

load('InputDataProject2.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
T=[T1;T2];
nFlows= size(T,1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);

% Matriz D -> atraso de propagacao
D = L/(2*10^5); % L -> Matriz com comprimento de todas ligacoes

% ex3 a)
% statement: "Consider now the optimization problem of computing
% a symmetrical single path routing solution to support both services
% which aims to minimize the average round-trip propagation delay of
% the service with the worst average round-trip delay and then the average
% round-trip propagation delay of the other service. Adapt the algorithm
% developed in task 1.b to address this optimization problem."
fprintf('\n3.a)\n\n');

%%% Computing up to k=2 shortest paths for all flows of service 1: %%%
% Compute up to n paths for each flow:
k = 2;
[sP, nSP]= calculatePaths(L,T,k, nFlows);

t= tic;
timeLimit= 20; % runtime limit of 60 seconds
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit % 1º while to detect the worst service roundtrip delay
    sol= zeros(1,nFlows);
    [sol, ~, linkEnergy] = Task3_GreedyRandomized(nNodes,Links,T,L,sP,nSP,sol);
    [sol, load, Loads, linkEnergy] = Task3_HillClimbing(sol,nNodes,Links,T,L,sP,nSP,linkEnergy);
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLinkEnergy = linkEnergy;
        bestTime= toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end 
% Calculate round-trip propagation delay
[worstDelay, otherDelay, worstService] = calculateServiceDelays(sP, sol, D, nFlows1, nFlows2);
fprintf('Worst Service %.4f\n', worstDelay*1000); % 5.0392 ms
fprintf('Other Service %.4f', otherDelay*1000); % 5.6113 ms

[sP, nSP]= calculatePaths(L,T,k, nFlows);
t= tic;
timeLimit= 20; % runtime limit of 60 seconds

bestAverageRoundTripWorstS = inf;
while toc(t) < timeLimit
    % sol= zeros(1,nFlows);
    if worstService == 1    % Minimize the worst service
        % Greedy Randomized (service 1)
        [sol,worstDelay, otherDelay, ~, linkEnergy] = Task3_GreedyRandomized_Otim_Delay(true, nNodes,Links,T,D,sP,nSP,sol, nFlows1, L);
        % fprintf('\naaaHHHHHHH Worst Service 1 %.4f', worstDelay*1000);
        % Hill Climbing using results of greedy (service 1)
        [sol,worstDelay, ~, load, Loads, linkEnergy]= Task3_HillClimbing_Otim_Delay(true, sol, nNodes, Links, T, D, sP, nSP, nFlows1, worstDelay, otherDelay, linkEnergy, L);
    else
        % Greedy Randomized (service 2)
        [sol,worstDelay, otherDelay, ~, linkEnergy] = Task3_GreedyRandomized_Otim_Delay(true, nNodes,Links,T,D,sP,nSP,sol, nFlows2, L);
        % fprintf('\naaaHHHHHHH Worst Service 2 %.4f', worstDelay*1000);
        % Hill Climbing using results of greedy (service 2)
        [sol,worstDelay, ~, load, Loads, linkEnergy]= Task3_HillClimbing_Otim_Delay(true, sol, nNodes, Links, T, D, sP, nSP, nFlows2, worstDelay, otherDelay, linkEnergy, L);
    end
    averageRoundTripDelayWorstS = worstDelay;
    if averageRoundTripDelayWorstS < bestAverageRoundTripWorstS
        bestAverageRoundTripWorstS = averageRoundTripDelayWorstS;
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLinkEnergy = linkEnergy;
        bestTime= toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end
bestRoundTripDelayWorstS = bestAverageRoundTripWorstS;
fprintf('\n\nWorst Service Otimized.\n');

t= tic;
timeLimit= 20; % runtime limit of 60 seconds

bestAverageRoundTripOtherS = inf;
while toc(t) < timeLimit % Minimize the other service
    if worstService == 2
        % Greedy Randomized (service 1)
        [sol, worstDelayy, otherDelayy, ~, linkEnergy] = Task3_GreedyRandomized_Otim_Delay(false, nNodes,Links,T,D,sP,nSP,sol, nFlows1, L);
        % Hill Climbing using results of greedy (service 1)
        [sol, ~, otherDelayy, load, Loads, linkEnergy]= Task3_HillClimbing_Otim_Delay(false, sol, nNodes, Links, T, D, sP, nSP, nFlows1, worstDelayy, otherDelayy, linkEnergy, L);
    else
        % Greedy Randomized (service 2)
        [sol, worstDelayy, otherDelayy, ~, linkEnergy] = Task3_GreedyRandomized_Otim_Delay(false, nNodes,Links,T,D,sP,nSP,sol, nFlows2, L);
        % Hill Climbing using results of greedy (service 2)
        [sol, ~, otherDelayy, load, Loads, linkEnergy]= Task3_HillClimbing_Otim_Delay(false, sol, nNodes, Links, T, D, sP, nSP, nFlows2, worstDelayy, otherDelayy, linkEnergy, L);
    end
    averageRoundTripDelayOtherS = otherDelayy;
    if averageRoundTripDelayOtherS < bestAverageRoundTripOtherS
        bestAverageRoundTripOtherS = averageRoundTripDelayOtherS;
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLinkEnergy = linkEnergy;
        bestTime= toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end
bestRoundTripDelayOtherS = bestAverageRoundTripOtherS;
fprintf('\nOther Service Otimized.\n\n');
% Calculate average Link Load
link_load_sum = 0;
for i=1:nLinks
    link_load_sum = link_load_sum + sum(bestLoads(i,3:4));
end
avgLinkLoadSol = link_load_sum/nLinks;

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T,sP,nNodes,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;

% Calculate links not supporting any traffic flow
linksNoTraffic = [];
for i=1:nLinks
    if sum(bestLoads(i,3:4)) == 0
        linksNoTraffic = [linksNoTraffic,i];
    end
end

fprintf('SERVICE values:\n\n');
fprintf('For k= %s and time=%s\n',int2str(k), int2str(timeLimit));
fprintf('Worst link load of the (best) solution = %.2f Gbps\n',bestLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol/2);
fprintf('Network energy comsuption of the solution = %.2f\n',total_energy);
fprintf('The WorstService was T%s\n',int2str(worstService));
fprintf('Average round-trip propagation delay of worstService = %.4f ms\n',bestRoundTripDelayWorstS*1000);
fprintf('Average round-trip propagation delay of otherService = %.4f ms\n',bestRoundTripDelayOtherS*1000);
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i=linksNoTraffic
    fprintf('\t%d -> %d\n',bestLoads(i,1),bestLoads(i,2));
end
fprintf('Number of cycles run by the algorithm = %d\n',contador);
fprintf('Time obtained best solution= %f sec\n\n',bestTime);
