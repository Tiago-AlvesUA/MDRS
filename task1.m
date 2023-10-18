clc;
clear all;
%% 1.a)
fprintf('A)\n');

Num = 20;
P = 1000;   %MUDAR PARA 100 000
alfa = 0.1;
rate = 1800;
f = 10000;  %MUDAR PARA 1 000 000, SO PQ POR AGR É MAIS RAPIDO VER SE FUNCIONA
C = [10 20 30 40];

APD = zeros(4, Num);
mAPD = zeros(4, 1);
term_APD = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, APD(i, j), ~, ~] = Simulator1(rate, C(i), f, P);
    end
    mAPD(i,1) = mean(APD(i,:));
    term_APD(i,1) = norminv(1-alfa/2) * sqrt(var(APD(i,:)) / Num);
end
fprintf('APD C10 (%%) = %.2e +- %.2e\n',mAPD(1,1),term_APD(1,1));
fprintf('APD C20 (%%) = %.2e +- %.2e\n',mAPD(2,1),term_APD(2,1));
fprintf('APD C30 (%%) = %.2e +- %.2e\n',mAPD(3,1),term_APD(3,1));
fprintf('APD C40 (%%) = %.2e +- %.2e\n',mAPD(4,1),term_APD(4,1));

figure(1);
bar(C, mAPD);
hold on;

er = errorbar(C, mAPD, term_APD);
er.Color = [1 0 0];
er.LineStyle = 'none';

hold off;

xlabel('C (Mbps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');

%% 1.b

%% 1.c) 
fprintf('C)\n');

C = 10;
rates = [1000 1300 1600 1900];
TT = zeros(4, Num);
mT = zeros(length(rates), 1);
term_Throughput = zeros(length(rates), 1);

APD = zeros(4, Num);
mAPD = zeros(4, 1);
term_APD = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, APD(i, j), ~, TT(i, j)] = Simulator1(rates(i), C, f, P);
    end

    mAPD(i,1) = mean(APD(i,:));
    term_APD(i,1) = norminv(1-alfa/2) * sqrt(var(APD(i,:)) / Num);

    mT(i,1) = rates(i) * mean(TT(i,:)); % tenho duvida se aqui multiplicamos por capacidade em bits
    term_APD(i,1) = norminv(1-alfa/2) * sqrt(var(TT(i,:)) / Num);
end

% Create figures
figure(2);
bar(rates, mAPD);
hold on;
er_APD = errorbar(rates, mAPD, term_APD);
er_APD.Color = [1 0 0];
er_APD.LineStyle = 'none';
hold off;
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');

figure(3);
bar(rates, mT);
hold on;
er_Throughput = errorbar(rates, mT, term_Throughput);
er_Throughput.Color = [1 0 0];
er_Throughput.LineStyle = 'none';
hold off;
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput with Error Bars');

% Display results for average packet delay and throughput
for r = 1:length(rates)
    fprintf('Average Packet Delay (rate = %d pps) = %.2f ms +- %.2f\n', rates(r), mAPD(r), term_APD(r));
    fprintf('Average Throughput (rate = %d pps) = %.2f Mbps +- %.2f\n', rates(r), mT(r), term_Throughput(r));
end




