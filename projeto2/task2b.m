% ----------------- Task 2 ----------------- %
clear all;
close all;
clc;

load('InputDataProject2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows1= size(T1,1);
nFlows2= size(T2,1);

% D = L/(2*10^5);
% 2a
% ----------------- Service 1 ----------------- %
k= 2;
sP= cell(1,nFlows1);
nSP= zeros(1,nFlows1);
for f=1:nFlows1
    [shortestPath, totalCost] = kShortestPath(L,T1(f,1),T1(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t = tic;
timeLimit = 60;
bestLinkEnergy= inf;
bestLoad = inf;
contador = 0;
somador = 0;
while toc(t) < timeLimit
    sol = zeros(1,nFlows1);
    [sol, ~, linkEnergy] = Task2_GreedyRandomized(nNodes,Links,T1,L,sP,nSP,sol);
    [sol, load, Loads, linkEnergy] = Task2_hillClimbing(sol,nNodes,Links,T1,L,sP,nSP,linkEnergy);

    if linkEnergy<bestLinkEnergy
        bestSol = sol;
        bestLoad = load;
        bestLoads = Loads;
        bestLinkEnergy = linkEnergy;
        bestTime = toc(t);
    end
    contador=contador+1;
    somador=somador+load;
end

% Calculate average Link Load
link_load_sum = 0;
for i=1:nLinks
    link_load_sum = link_load_sum + sum(bestLoads(i,3:4));
end
avgLinkLoadSol = link_load_sum/nLinks;

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T1,sP,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;

% Calculate links not supporting any traffic flow
linksNoTraffic = [];
for i=1:nLinks
    if sum(bestLoads(i,3:4)) == 0
        linksNoTraffic = [linksNoTraffic,i];
    end
end

fprintf('\nSERVICE 1 values:\n\n');
fprintf('Worst link load of the (best) solution = %.2f Gbps\n',bestLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol);
fprintf('Network energy comsuption of the solution = %.2f\n',total_energy);
%fprintf('Average round-trip propagation delay of each service');
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i=linksNoTraffic
    fprintf('\t%d -> %d\n',bestLoads(i,1),bestLoads(i,2));
end
fprintf('Number of cycles run by the algorithm = %d\n',contador);
fprintf('Time obtained best solution= %f sec\n\n',bestTime);

% ----------------- Service 2 ----------------- %
sP= cell(1,nFlows2);
nSP= zeros(1,nFlows2);
for f=1:nFlows2
    [shortestPath, totalCost] = kShortestPath(L,T2(f,1),T2(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 60; % runtime limit of 60 seconds
bestLinkEnergy= inf;
bestLoad = inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows2);
    [sol, ~, linkEnergy] = Task2_GreedyRandomized(nNodes,Links,T2,L,sP,nSP,sol);
    [sol, load, Loads, linkEnergy] = Task2_hillClimbing(sol,nNodes,Links,T2,L,sP,nSP,linkEnergy);

    if linkEnergy<bestLinkEnergy
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLinkEnergy = linkEnergy;
        bestTime= toc(t);
    end

    contador= contador+1;
    somador= somador+load;
end

% Calculate average Link Load
link_load_sum = sum(bestLoads(:, 3:4), 2); % Soma os TT ida e volta
avgLinkLoadSol = mean(link_load_sum); % Calcula a média dos valores da soma para obter a média do Link Load

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T2,sP,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;

% Calculate links not supporting any traffic flow
linksNoTraffic = [];
for i=1:nLinks
    if sum(bestLoads(i,3:4)) == 0
        linksNoTraffic = [linksNoTraffic,i];
    end
end

fprintf('\nSERVICE 2 values:\n\n');
fprintf('Worst link load of the (best) solution = %.2f Gbps\n',bestLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol); % 44.66 Gbps
fprintf('Network energy comsuption of the solution = %.2f\n', total_energy);
%fprintf('Average round-trip propagation delay of each service');
fprintf('Number of links not supporting any traffic flow = %d\n', length(linksNoTraffic));
fprintf('List of links not supporting any traffic flow:\n');
for i=linksNoTraffic
    fprintf('\t%d -> %d\n',bestLoads(i,1),bestLoads(i,2));
end
fprintf('Number of cycles run by the algorithm = %d\n',contador);
fprintf('Time obtained best solution= %f sec\n\n',bestTime);