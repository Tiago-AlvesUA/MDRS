load('ex2.mat');
%% ALINEA A)
% Crie uma única figura
figure(1);


% Configure a primeira subplot
subplot(2, 2, 1);
bar(n, mean_APD_data);
hold on;

er = errorbar(n, mean_APD_data, term_APD_data);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of Data');
grid on;
hold off;

% Configure a segunda subplot
subplot(2, 2, 2);
bar(n, mean_APD_voip);
hold on;
er = errorbar(n, mean_APD_voip, term_APD_voip);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of VoIP');
grid on;
hold off;

% Configure a terceira subplot
subplot(2, 2, 3);
bar(n, mean_AQD_data);
hold on;
er = errorbar(n, mean_AQD_data, term_AQD_data);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of Data');
grid on;
hold off;

% Configure a quarta subplot
subplot(2, 2, 4);
bar(n, mean_AQD_voip);
hold on;
er = errorbar(n, mean_AQD_voip, term_AQD_voip);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of VoIP');
grid on;
hold off;


%% ALINEA B)
figure(2);

% Configure a primeira subplot
subplot(2, 2, 1);
hold on;
bar(n, [mean_APD_data, mean_APD_data_Priority]);
er = errorbar((n-1.5), mean_APD_data, term_APD_data);
er.Color = [1 0 0];
er.LineStyle = "none";
er = errorbar((n+1.5), mean_APD_data_Priority, term_APD_data_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of Data');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

% Configure a segunda subplot
subplot(2, 2, 2);
hold on;
bar(n, [mean_APD_voip, mean_APD_voip_Priority]);
er = errorbar((n-1.5), mean_APD_voip, term_APD_voip);
er.Color = [1 0 0];
er.LineStyle = "none";
er = errorbar((n+1.5), mean_APD_voip_Priority, term_APD_voip_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of VoIP');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

% Configure a terceira subplot
subplot(2, 2, 3);
hold on;
bar(n, [mean_AQD_data, mean_AQD_data_Priority]);
er = errorbar((n-1.5), mean_AQD_data, term_AQD_data);
er.Color = [1 0 0];
er.LineStyle = "none";
er = errorbar((n+1.5), mean_AQD_data_Priority, term_AQD_data_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of Data');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;

% Configure a quarta subplot
subplot(2, 2, 4);
hold on;
bar(n, [mean_AQD_voip, mean_AQD_voip_Priority]);
er = errorbar((n-1.5), mean_AQD_voip, term_AQD_voip);
er.Color = [1 0 0];
er.LineStyle = "none";
er = errorbar((n+1.5), mean_AQD_voip_Priority, term_AQD_voip_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";
xlabel('n VoIP flows');
xticks(n);
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of VoIP');
legend({'Without priority higher to VoIP', 'With priority higher to VoIP'}, 'Location', 'NorthWest');
ylim([0 8]);
set(gca, 'ColorOrder', [0 0 0.8; 0 0.8 0.5]);
grid on;
hold off;
