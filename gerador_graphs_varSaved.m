% Carregue as variáveis do arquivo .mat
load('1e_simuladorAlterado.mat');

% Crie o gráfico para a média do Atraso Médio de Pacotes
figure(4);
grid on;
bar(rates, mean_APD);
hold on;
er_APD = errorbar(rates, mean_APD, term_APD);
er_APD.Color = [1 0 0];
er_APD.LineStyle = 'none';
hold off;
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars (BER)');

% Crie o gráfico para a média da Taxa de Transferência Média
figure(5);
grid on;
bar(rates, mean_Throughput);
hold on;
er_Throughput = errorbar(rates, mean_Throughput, term_Throughput);
er_Throughput.Color = [1 0 0];
er_Throughput.LineStyle = 'none';
hold off;
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
title('Average Throughput with Error Bars (BER)');
