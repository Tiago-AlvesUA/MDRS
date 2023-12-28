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
timeLimit= 2; % runtime limit of 60 seconds
bestLoad = inf;
bestLoads = inf;
bestLinkEnergy = inf;
bestDelay= inf;
Loads = inf;

contador= 0;
somador= 0;
while toc(t) < timeLimit
    % sol = zeros(1,nFlows);
    
    [sol, ~, linkEnergy] = Task3_GreedyRandomized_Otim_Delay(nNodes,Links,T,L,sP,nSP);
    while linkEnergy == inf
        [sol, ~, linkEnergy] = Task3_GreedyRandomized_Otim_Delay(nNodes,Links,T,L,sP,nSP);
    end

    [sol, load, Loads, linkEnergy, delay] = Task3_HillClimbing_Otim_Delay(sol,nNodes,Links,T,D,sP,nSP,L,nFlows1,linkEnergy);
    
     if delay < bestDelay
        bestSol= sol;
        bestDelay = delay;
        bestLoad= load;
        bestLoads=Loads;
        bestLinkEnergy = linkEnergy;
        bestTime= toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end

% Calculate average Link Load
link_load_sum = 0;
for i=1:nLinks
    link_load_sum = link_load_sum + sum(bestLoads(i,3:4));
end
avgLinkLoadSol = link_load_sum/nLinks;

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T,sP,nNodes,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;

% Calculate round-trip propagation delay
roundTripDelays = zeros(1,nFlows1);
for f = 1:nFlows1   
    if bestSol(f) ~= 0
        path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
        total_delay = 0;
        for j=2:length(path)
            propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
            total_delay = total_delay + propagation_delay;
        end
        roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
    end
end
averageRoundTripDelay1 = mean(roundTripDelays);

roundTripDelays = zeros(1,nFlows2);
for f = 13:nFlows2+12
    if bestSol(f) ~= 0
        path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
        total_delay = 0;
        for j=2:length(path)
            propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
            total_delay = total_delay + propagation_delay;
        end
        roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
    end
end
averageRoundTripDelay2 = mean(roundTripDelays);

% Calculate links not supporting any traffic flow
linksNoTraffic = [];
for i=1:nLinks
    if sum(bestLoads(i,3:4)) == 0
        linksNoTraffic = [linksNoTraffic,i];
    end
end

fprintf('For k= %s and time=%s\n',int2str(k), int2str(timeLimit));
fprintf('Worst link load of the (best) solution = %.2f Gbps\n',bestLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol/2);
fprintf('Network energy comsuption of the solution = %.2f\n',total_energy);
fprintf('Average round-trip propagation delay of service 1 = %f sec\n',averageRoundTripDelay1);
fprintf('Average round-trip propagation delay of service 2 = %f sec\n',averageRoundTripDelay2);
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i=linksNoTraffic
    fprintf('\t%d -> %d\n',bestLoads(i,1),bestLoads(i,2));
end
fprintf('Number of cycles run by the algorithm = %d\n',contador);
fprintf('Time obtained best solution= %f sec\n\n',bestTime);
