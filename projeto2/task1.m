clear all
close all
clc

load('InputDataProject2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
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

%% ex1 b)

%%% Computing up to k=2 shortest paths for all flows of service 1: %%%
k= 2;
sP= cell(1,nFlows1);
nSP= zeros(1,nFlows1);
for f=1:nFlows1
    [shortestPath, totalCost] = kShortestPath(L,T1(f,1),T1(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 2; % runtime limit of 60 seconds
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows1);
    [sol, ~] = greedyRandomized(nNodes,Links,T1,sP,nSP,sol);
    
    [sol, load, Loads] = hillClimbing(sol,nNodes,Links,T1,sP,nSP);

    if load<bestLoad
        bestSol= sol;
        bestLoad= load; % Substituir por maxLoad para melhor percecao?
        bestLoads= Loads;
        bestTime= toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end

link_load_sum = 0;
for i=1:nLinks
    link_load_sum = link_load_sum + sum(bestLoads(i,3:4));
end
avgLinkLoadSol = link_load_sum/nLinks;

fprintf('\nSERVICE 1 values:\n\n');
fprintf('Worst link load of the (best) solution = %.2f Gbps\n',bestLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol);
%fprintf('Network energy comsuption of the solution');
%fprintf('Average round-trip propagation delay of each service');
%fprintf('Number (and list) of links not supporting any traffic flow');
fprintf('Number of cycles run by the algorithm = %d\n',contador);
fprintf('Time obtained best solution= %f sec\n\n',bestTime);


%%% Computing up to k=2 shortest paths for all flows of service 2: %%%
k= 2;
sP= cell(1,nFlows2);
nSP= zeros(1,nFlows2);
for f=1:nFlows2
    [shortestPath, totalCost] = kShortestPath(L,T2(f,1),T2(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t= tic;
timeLimit= 2; % runtime limit of 60 seconds
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows2);
    [sol, ~] = greedyRandomized(nNodes,Links,T2,sP,nSP,sol);
    
    [sol, load, Loads] = hillClimbing(sol,nNodes,Links,T2,sP,nSP);

    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestTime= toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end

link_load_sum = 0;
for i=1:nLinks
    link_load_sum = link_load_sum + sum(bestLoads(i,3:4));
end
avgLinkLoadSol = link_load_sum/nLinks;

fprintf('\nSERVICE 2 values:\n\n');
fprintf('Worst link load of the (best) solution = %.2f Gbps\n',bestLoad);
fprintf('Average link load of the solution = %.2f Gbps\n', avgLinkLoadSol);
%fprintf('Network energy comsuption of the solution');
%fprintf('Average round-trip propagation delay of each service');
%fprintf('Number (and list) of links not supporting any traffic flow');
fprintf('Number of cycles run by the algorithm = %d\n',contador);
fprintf('Time obtained best solution= %f sec\n\n',bestTime);



