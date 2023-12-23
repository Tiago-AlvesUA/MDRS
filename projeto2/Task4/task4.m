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

anycastNodes = [3 10];

%% a)
% Computing up to k=2 shortest paths for all flows:
k= 2;
sP_Unicast= cell(1,nFlowsUnicast);
nSP_Unicast= zeros(1,nFlowsUnicast);
for f=1:nFlowsUnicast
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP_Unicast{f}= shortestPath;
    nSP_Unicast(f)= length(totalCost);
end

[sP_Anycast,nSP_Anycast]= bestCostPaths(nNodes,anycastNodes,L,T3);

% Add destination nodes no anycast matrix T3
T3 = [T3(:,1) zeros(size(T3,1),1) T3(:,2:3)];
for i= 1:size(T3,1)
    T3(i,2) = sP_Anycast{i}{1}(end);
end

% Concatenate unicast and anycast T's, sP's and nSP's
T = [T_Unicast; T3];
sP = cat(2, sP_Unicast, sP_Anycast);
nSP = cat(2, nSP_Unicast, nSP_Anycast);






