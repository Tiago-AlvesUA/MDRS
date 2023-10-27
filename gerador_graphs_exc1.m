load('ex1.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
bar(C, mean_APD);
hold on;

er = errorbar(C, mean_APD, term_APD);
er.Color = [1, 0, 0];
er.LineStyle = "none";

xlabel('C (Mbps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');
grid on; hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
bar(rates, mean_APD);
hold on;
er = errorbar(rates, mean_APD, term_APD);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('Packet Arrival Rate (pps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');
grid on; hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3);
bar(rates, mean_Throughput);
hold on;
er= errorbar(rates, mean_Throughput, term_Throughput);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput with Error Bars');
grid on; hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Crie o gráfico para a média do Atraso Médio de Pacotes
figure(4);
bar(rates, mean_APD);
hold on;
er_APD = errorbar(rates, mean_APD, term_APD);
er_APD.Color = [1 0 0];
er_APD.LineStyle = 'none';

xlabel('Packet Arrival Rate (pps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars (BER)');
grid on; hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Crie o gráfico para a média da Taxa de Transferência Média
figure(5);

bar(rates, mean_Throughput);
hold on;
er = errorbar(rates, mean_Throughput, term_Throughput);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput with Error Bars (BER)');
grid on; hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%