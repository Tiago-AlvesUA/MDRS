clear all;
close all;
clc;

load('InputDataProject2.mat');
nNodes = size(Nodes, 1);
nLinks = size(Links, 1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);
T = [T1; T2];
nFlows = size(T, 1);

% Matriz D -> atraso de propagacao
D = L / (2 * 10^5); % L -> Matriz com comprimento de todas ligacoes

%% 2.a) Energy Optimization
fprintf('\n2.b) Energy Optimization\n\n');

% Computing up to k=2 shortest paths for all flows:
k= 2;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t = tic;
timeLimit = 60; % runtime limit of 60 seconds
bestEnergy = inf;
contador = 0;
bestLoad = inf;
somador = 0;
while toc(t) < timeLimit
    sol = zeros(1, nFlows);
    [sol, ~, linkEnergy] = Task2a_GreedyRandomized_EnergyOptimized(nNodes, Links, T, L, sP, nSP, sol);
    [sol, load, Loads, linkEnergy] = Task2a_hillClimbing_EnergyOptimized(sol, nNodes, Links, T, L, sP, nSP, linkEnergy);
    if linkEnergy < bestEnergy
        bestSol = sol;
        bestLoad = load;
        bestLoads = Loads;
        bestEnergy = linkEnergy;
        bestTime = toc(t);
    end
    contador = contador + 1;
    somador=somador+load;
end

% Calculate energy consumption
nodesEnergy = calculateNodeEnergy(T, sP, nNodes, bestSol);
total_energy = nodesEnergy + bestEnergy;

% Calculate round-trip propagation delay
roundTripDelays = zeros(1,nFlows1);
for f = 1:nFlows1   
    path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
    total_delay = 0;
    for j=2:length(path)
        propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
        total_delay = total_delay + propagation_delay;
    end
    roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
end
totalRoundTripDelay = sum(roundTripDelays);
averageRoundTripDelay1 = totalRoundTripDelay / nFlows1;

roundTripDelays = zeros(1,nFlows2);
for f = 13:nFlows2+12   
    path= sP{f}{bestSol(f)}; % Para cada fluxo vamos buscar o caminho solucao
    total_delay = 0;
    for j=2:length(path)
        propagation_delay = D(path(j-1), path(j)); % D matrix represents propagation delays
        total_delay = total_delay + propagation_delay;
    end
    roundTripDelays(f) = 2*total_delay; % 2x because it's round trip delay
end
totalRoundTripDelay = sum(roundTripDelays);
averageRoundTripDelay2 = totalRoundTripDelay / nFlows2;


% Calculate average Link Load
link_load_sum = sum(Loads(:, 3)) + sum(Loads(:, 4));
avgLinkLoadSol = link_load_sum / (2 * nLinks);
worstLinkLoad = max(max(Loads(:, 3:4)));

% Calculate round-trip propagation delay
roundTripDelays = zeros(1, nFlows);
for f = 1:nFlows
    path = sP{f}{bestSol(f)};
    total_delay = 0;
    for j = 2:length(path)
        total_delay = total_delay + D(path(j - 1), path(j));
    end
    roundTripDelays(f) = 2 * total_delay; % 2x because it's round trip delay
end
averageRoundTripDelay = mean(roundTripDelays);

% Calculate links not supporting any traffic flow
linksNoTraffic = find(sum(Loads(:, 3:4), 2) == 0);

fprintf('Worst link load of the solution = %.2f Gbps\n', worstLinkLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol);
fprintf('Total network energy consumption of the solution = %.2f\n', total_energy);

fprintf('Average round-trip propagation delay of service 1 = %f sec\n',averageRoundTripDelay1);
fprintf('Average round-trip propagation delay of service 2 = %f sec\n',averageRoundTripDelay2);
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i = linksNoTraffic'
    fprintf('\t%d -> %d\n', Loads(i, 1), Loads(i, 2));
end
fprintf('Number of cycles run by the algorithm = %d\n', contador);
fprintf('Time obtained best solution = %f sec\n', bestTime);
