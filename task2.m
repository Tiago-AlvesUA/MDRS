clc;
clear all;
%% 2.a

lambda = 1500;
C = 10;
f = 1000000;
N = 20;
P = 100000;
alfa = 0.1;
n = [10 20 30 40];

APD_d = zeros(4,N);
APD_v = zeros(4,N);
AQD_d = zeros(4,N);
AQD_v = zeros(4,N);

mean_APD_data = zeros(1, 4);
term_APD_data = zeros(1, 4);
mean_APD_voip = zeros(1, 4);
term_APD_voip = zeros(1, 4);

mean_AQD_data = zeros(1, 4);
term_AQD_data = zeros(1, 4);
mean_AQD_voip = zeros(1, 4);
term_AQD_voip = zeros(1, 4);

for i = 1:4
    for j = 1:N
        [~, ~, APD_d(i,j), APD_v(i,j), AQD_d(i,j), AQD_v(i,j), ~, ~, ~] = Simulator3(lambda, C, f, P, n(i));
    end
    
    % calculo do average delay of data packets
    mean_APD_data(i,1) = mean(APD_d(i,:));
    term_APD_data(i,1) = norminv(1-alfa/2) * sqrt(var(APD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_APD_voip(i,1) = mean(APD_v(i,:));
    term_APD_voip(i,1) = norminv(1-alfa/2) * sqrt(var(APD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('APD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_data(i,1),term_APD_data(i,1));
    fprintf('APD voip n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_voip(i,1),term_APD_voip(i,1));

    % calculo do average delay of data packets
    mean_AQD_data(i,1) = mean(AQD_d(i,:));
    term_AQD_data(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_AQD_voip(i,1) = mean(AQD_v(i,:));
    term_AQD_voip(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('AQD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_AQD_data(i,1),term_AQD_data(i,1));
    fprintf('AQD voip n%d Mbps (ms) = %.2e +- %.2e\n\n',n(i),mean_AQD_voip(i,1),term_AQD_voip(i,1));
end
%%%
figure(1);
bar(n, mean_APD_data);
hold on;

er = errorbar(n, mean_APD_data, term_APD_data);

xlabel('n VoIP flows');
ylabel('Average Delay of Data Packets(ms)');
title('Average Delay of Data Packets with Error Bars');
hold off;

%%%
figure(2);
bar(n, mean_APD_voip);
hold on;

er = errorbar(n, mean_APD_voip, term_APD_voip);

xlabel('n VoIP flows');
ylabel('Average Delay of VoIP Packets(ms)');
title('Average Delay of VoIP Packets with Error Bars');
hold off;

figure(3);
bar(n, mean_AQD_data);
hold on;

er = errorbar(n, mean_AQD_data, term_AQD_data);


xlabel('n VoIP flows');
ylabel('QUEUEing Delay of Data Packets(ms)');
title('QUEUEing Delay of Data Packets with Error Bars');
hold off;

%%%
figure(4);
bar(n, mean_AQD_voip);
hold on;

er = errorbar(n, mean_AQD_voip, term_AQD_voip);

xlabel('n VoIP flows');
ylabel('QUEUEing Delay of VoIP Packets(ms)');
title('QUEUEing Delay of VoIP Packets with Error Bars');
hold off;

%% 2.b

lambda = 1500;
C = 10;
f = 1000000;
N = 20;
P = 1000;     %% P = 100.000 MUDAR NO FUTURO  
alfa = 0.1;
n = [10 20 30 40];

APD_d = zeros(4,N);
APD_v = zeros(4,N);
AQD_d = zeros(4,N);
AQD_v = zeros(4,N);

mean_APD_data = zeros(1, 4);
term_APD_data = zeros(1, 4);
mean_APD_voip = zeros(1, 4);
term_APD_voip = zeros(1, 4);

mean_AQD_data = zeros(1, 4);
term_AQD_data = zeros(1, 4);
mean_AQD_voip = zeros(1, 4);
term_AQD_voip = zeros(1, 4);

for i = 1:4
    for j = 1:N
        [~, ~, APD_d(i,j), APD_v(i,j), AQD_d(i,j), AQD_v(i,j), ~, ~, ~] = Simulator4(lambda, C, f, P, n(i));
    end
    
    % calculo do average delay of data packets
    mean_APD_data(i,1) = mean(APD_d(i,:));
    term_APD_data(i,1) = norminv(1-alfa/2) * sqrt(var(APD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_APD_voip(i,1) = mean(APD_v(i,:));
    term_APD_voip(i,1) = norminv(1-alfa/2) * sqrt(var(APD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('Priority APD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_data(i,1),term_APD_data(i,1));
    fprintf('Priority APD voip n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_APD_voip(i,1),term_APD_voip(i,1));

    % calculo do average delay of data packets
    mean_AQD_data(i,1) = mean(AQD_d(i,:));
    term_AQD_data(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_d(i,:)) / N);
    % calculo do average delay of voip packets
    mean_AQD_voip(i,1) = mean(AQD_v(i,:));
    term_AQD_voip(i,1) = norminv(1-alfa/2) * sqrt(var(AQD_v(i,:)) / N);

    % calculo do average queuing delay of VoIP packets

    fprintf('Priority AQD data n%d Mbps (ms) = %.2e +- %.2e\n',n(i),mean_AQD_data(i,1),term_AQD_data(i,1));
    fprintf('Priority AQD voip n%d Mbps (ms) = %.2e +- %.2e\n\n',n(i),mean_AQD_voip(i,1),term_AQD_voip(i,1));
end
%%%
figure(5);
grid on;
bar(n, mean_APD_data);
hold on;

er = errorbar(n, mean_APD_data, term_APD_data);


xlabel('n VoIP flows');
ylabel('Average Delay of Data Packets(ms)');
title('Average Delay of Data Packets with Error Bars');
hold off;

%%%
figure(6);
grid on;
bar(n, mean_APD_voip);
hold on;

er = errorbar(n, mean_APD_voip, term_APD_voip);

xlabel('n VoIP flows');
ylabel('Average Delay of VoIP Packets(ms)');
title('Average Delay of VoIP Packets with Error Bars');
hold off;

figure(7);
grid on;
bar(n, mean_AQD_data);
hold on;

er = errorbar(n, mean_AQD_data, term_AQD_data);


xlabel('n VoIP flows');
ylabel('Priority QUEUEing Delay of Data Packets(ms)');
title('Priority QUEUEing Delay of Data Packets with Error Bars');
hold off;

%%%
figure(8);
grid on;
bar(n, mean_AQD_voip);
hold on;

er = errorbar(n, mean_AQD_voip, term_AQD_voip);

xlabel('n VoIP flows');
ylabel('Priority QUEUEing Delay of VoIP Packets(ms)');
title('Priority QUEUEing Delay of VoIP Packets with Error Bars');
hold off;

%% 2.c)
fprintf('\nC)\n');
C = C * 10^6; % Convert capacity to bps
perc_left = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 64) + (1517 - 110));
nMedio = (64)*0.19 + (110)*0.23 + (1518)*0.17 ...
    + sum((65:109) * perc_left) + sum((111:1518) * perc_left); %bytes

% tamanho dos pacotes voip é randi([110 130])
% taxa de chegada do tipo voip é 1 a ([16 24])
size_voip = randi([110 130]); %bytes
taxa_voip = randi([16 24])* 10^-3; %ms
lambda_voip = 1/taxa_voip;
u_voip = 10e6/(8*size_voip); % convert to pps -> depois dentro do for * pelos voip flows
S_v = 1/u_voip; % Service time, S
S2_v = 1/(u_voip^2); % S^2

lambda = 1500;
u = 10e6/(8*nMedio);
S = 1/u; % Service time, S
S2 = 1/(u^2); % S^2

n = [10 20 30 40]; % Number of VoIP packet flows

APDv = zeros(1, 4); % Initialize an array for VoIP APD

fprintf('Valores teóricos\n');
for i = 1:4
    % pk = lambda_k * E[S_k]
    pA = (lambda_voip* n(i)) * S_v;
    wA = ((lambda_voip * S2_v + lambda * S2) / (2 * (1 - pA))) + S_v;
    APDv(i) = wA;
    fprintf('n=%d: w = %0.2f ms\n', n(i), wA*1e3);
end

figure(9);
grid on;
bar(n, APDv);
title('APD for VoIP Packets');
xlabel('Number of VoIP packet Flows');
ylabel('APD_v (ms)');