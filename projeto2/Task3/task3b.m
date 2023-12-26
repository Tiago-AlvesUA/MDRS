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

% 3.a) Energy Optimization
fprintf('\n3.b) Delays Optimization\n\n');

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

    [sol, Loads, totalEnergy] = Task3_GreedyRandomized(nNodes, Links, T, L, sP, nSP, sol);

    [sol, load, Loads, totalEnergy] = Task3_hillClimbing(sol, nNodes, Links, T, L, sP, nSP, totalEnergy, Loads);
    
    % instead this comparing maybe we need to compare delays to minimize
    % delay of round trip
    if totalEnergy < bestEnergy
        bestSol = sol;
        bestLoad = load;
        bestLoads = Loads;
        bestEnergy = totalEnergy;
        bestTime = toc(t);
    end
    contador = contador + 1;
    somador=somador+load;
end

% Calculate round-trip propagation delay

% Calculate average Link Load
link_load_sum = sum(Loads(:, 3)) + sum(Loads(:, 4));
avgLinkLoadSol = link_load_sum / (2 * nLinks);
worstLinkLoad = max(max(Loads(:, 3:4)));

% Calculate links not supporting any traffic flow
linksNoTraffic = find(sum(Loads(:, 3:4), 2) == 0);

fprintf('Worst link load of the solution = %.2f Gbps\n', worstLinkLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol/2);
fprintf('Total network energy consumption of the solution = %.2f\n', bestEnergy);

fprintf('Average round-trip propagation delay of service 1 = %f sec\n',averageRoundTripDelay1);
fprintf('Average round-trip propagation delay of service 2 = %f sec\n',averageRoundTripDelay2);
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i = linksNoTraffic'
    fprintf('\t%d -> %d\n', Loads(i, 1), Loads(i, 2));
end
fprintf('Number of cycles run by the algorithm = %d\n', contador);
fprintf('Time obtained best solution = %f sec\n', bestTime);