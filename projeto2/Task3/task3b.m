% ----------------- Task 2 ----------------- %
clear all;
close all;
clc;

load('InputDataProject2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
T = [T1;T2];
nFlows1= size(T1,1);
nFlows2= size(T2,1);

D = L/(2*10^5);
%% 2a
% ----------------- Service 1 ----------------- %
k= 2;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

% Initialize the algorithm
sol = zeros(1, nFlows);
bestLoad = inf;
bestAverageDelay = inf;
bestLinkEnergy = inf;
bestSolution = sol;
bestLoads = [];

t = tic;
timeLimit = 60; % Runtime limit of 60 seconds
while toc(t) < timeLimit
    % Call your adapted Greedy Randomized function
    [sol, averageDelay, linkEnergy] = Task1_GreedyRandomized(nNodes, Links, T, D, sP, nSP, sol);
    
    % Call your adapted Hill Climbing function
    [sol, averageDelay, Loads, linkEnergy] = Task1_hillClimbing(sol, nNodes, Links, T, D, sP, nSP, linkEnergy);

    % Check if the current solution is better than the best found so far
    if averageDelay < bestAverageDelay
        bestSolution = sol;
        bestAverageDelay = averageDelay;
        bestLinkEnergy = linkEnergy;
        bestLoads = Loads;
    end
end

% Record the requested values for the best solution
[~, ~, roundTripDelays] = calculateLinkLoads(nNodes, Links, T, D, sP, bestSolution);
[bestAverageDelay, ~] = calculateAverageRoundTripDelay(roundTripDelays, T);

fprintf('Best Average Round-Trip Delay: %f seconds\n', bestAverageDelay);

% Calculate energy comsuption
nodesEnergy = calculateNodeEnergy(T,sP,bestSol);
total_energy = nodesEnergy + bestLinkEnergy;

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


fprintf('\nBest average round-trip delay = %.2f\n', bestMinDelay);
fprintf('Network energy comsuption of the solution = %.2f\n',total_energy);
fprintf('Best link energy consumption = %.2f\n', bestLinkEnergy);
fprintf('Time to obtain best solution = %f sec\n', bestTime);
fprintf('Number of algorithm iterations = %d\n', contador);
