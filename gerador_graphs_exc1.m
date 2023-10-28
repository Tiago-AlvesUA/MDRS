clc;clear ALL;
load('ex1.mat');
%% 1.a
figure(1);
bar(C, mean_APD_C);
hold on;

errorbar(C, mean_APD_C, term_APD_C);


xlabel('C (Mbps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');
grid on; 
hold off;

%% 1.c&d
figure(2);

% Primeiro subplot - Average Packet Delay
subplot(1, 2, 1);
hold on;
bar(rates, [mean_APD, mean_APD_ber]);
errorbar((rates-45), mean_APD, term_APD, 'r.', 'MarkerSize', 5, 'LineStyle', 'none');
errorbar((rates+45), mean_APD_ber, term_APD_ber, 'b.', 'MarkerSize', 5, 'LineStyle', 'none');

xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylim([0 10]);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay');
legend({'Without BER', 'With BER'}, 'Location','northwest');
grid on;
hold off;

% Segundo subplot - Average Throughput
subplot(1, 2, 2);
hold on;
bar(rates, [mean_Throughput, mean_Throughput_ber]);
errorbar(rates - 45, mean_Throughput, term_Throughput, 'r.', 'MarkerSize', 10, 'LineStyle', 'none');
errorbar(rates + 45, mean_Throughput_ber, term_Throughput_ber, 'b.', 'MarkerSize', 10, 'LineStyle', 'none');
xticks(rates);
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput');
legend({'Without BER', 'With BER'}, 'Location','northwest');
grid on;
hold off;