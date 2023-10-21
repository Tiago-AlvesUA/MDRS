clc;
clear all;
%% 2.a

lambda = 1500;
C = 10;
f = 1000000;
N = 20;
P = 1000;     %% P = 100.000 MUDAR NO FUTURO  
alfa = 0.1;
n = [10 20 30 40];

APD_d = zeros(4,N);
APD_v = zeros(4,N);
% FALTA average queuing

mean_APD_data = zeros(1, 4);
term_APD_data = zeros(1, 4);
mean_APD_voip = zeros(1, 4);
term_APD_voip = zeros(1, 4);
% FALTA average queuing

for i = 1:4
    for j = 1:N
        [~, ~, APD_d(i,j), APD_v(i,j), ~, ~, ~] = Simulator3(lambda, C, f, P, n(i));
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
% FALTA DO AVERAGE QUEUING 