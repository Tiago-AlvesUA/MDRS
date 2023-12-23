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



%% ex1 a)
% Não seria a melhor solução porque estaríamos a enviar todo o tráfego por
% um só caminho, o que causaria congestão dos pacotes, levando a maior
% perda de pacotes e latência (Cada ligação tem uma capacidade de ligação de 
% 100 Gbps, valor que seria ultrapassado por muito se contarmos o throughput 
% de todos os fluxos juntos). Uma melhor solução tendo em conta a engenharia 
% de tráfego visaria vários parâmetros de optimização, não só apenas o atraso de
% propagação mas também a capacidade dos links, consumo de energia, etc.

% rever, secalhar nao é preciso ser tao detalhado e so indicar que soma de
% todo throughput dos fluxos ultrapassa os 100Gbps da capacidade das
% ligaçoes
%% ex1 b)
fprintf('\n1.b)\n\n');

%%% Computing up to k=2 shortest paths for all flows of service 1: %%%
k= 2;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 60; % runtime limit of 60 seconds
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    [sol, ~, linkEnergy] = Task1_GreedyRandomized(nNodes,Links,T,L,sP,nSP,sol);
    
    [sol, load, Loads, linkEnergy] = Task1_hillClimbing(sol,nNodes,Links,T,L,sP,nSP,linkEnergy);

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

% Calculate links not supporting any traffic flow
linksNoTraffic = [];
for i=1:nLinks
    if sum(bestLoads(i,3:4)) == 0
        linksNoTraffic = [linksNoTraffic,i];
    end
end

fprintf('\nSERVICE values:\n\n');
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

%% ex1 c)
fprintf('\n1.c)\n\n');

%%% Computing up to k=2 shortest paths for all flows of service 1: %%%
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 60; % runtime limit of 60 seconds
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    [sol, ~, linkEnergy] = Task1_GreedyRandomized(nNodes,Links,T,L,sP,nSP,sol);
    
    [sol, load, Loads, linkEnergy] = Task1_hillClimbing(sol,nNodes,Links,T,L,sP,nSP,linkEnergy);

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

% Calculate links not supporting any traffic flow
linksNoTraffic = [];
for i=1:nLinks
    if sum(bestLoads(i,3:4)) == 0
        linksNoTraffic = [linksNoTraffic,i];
    end
end

fprintf('\nSERVICE values:\n\n');
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