load('ex2a_b.mat');
%% ALINEA A)
figure(1);
bar(n, mean_APD_data);
hold on;

er = errorbar(n, mean_APD_data, term_APD_data);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
%ylim([0 8]);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of Data');
hold off;

figure(2);
bar(n, mean_APD_voip);
hold on;

er = errorbar(n, mean_APD_voip, term_APD_voip);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of VoIP');
hold off;

figure(3);
bar(n, mean_AQD_data);
hold on;

er = errorbar(n, mean_AQD_data, term_AQD_data);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
%ylim([0 7]);
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of Data');
hold off;

figure(4);
bar(n, mean_AQD_voip);
hold on;

er = errorbar(n, mean_AQD_voip, term_AQD_voip);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of VoIP');
hold off;

%% ALINEA B)
figure(5);
grid on;
bar(n, mean_APD_data_Priority);
hold on;

er = errorbar(n, mean_APD_data_Priority, term_APD_data_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of Data - VoIP with higher priority');
hold off;

figure(6);
grid on;
bar(n, mean_APD_voip_Priority);
hold on;

er = errorbar(n, mean_APD_voip_Priority, term_APD_voip_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
%ylim([0 6]);
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay of VoIP - VoIP with higher priority');
hold off;

figure(7);
grid on;
bar(n, mean_AQD_data_Priority);
hold on;

er = errorbar(n, mean_AQD_data_Priority, term_AQD_data_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of Data - VoIP with higher priority');
hold off;

figure(8);
grid on;
bar(n, mean_AQD_voip_Priority);
hold on;

er = errorbar(n, mean_AQD_voip_Priority, term_AQD_voip_Priority);
er.Color = [1 0 0];
er.LineStyle = "none";

xlabel('n VoIP flows');
%ylim([0 6]);
ylabel('Average Queue Delay (ms)');
title('Average Queue Delay of VoIP - VoIP with higher priority');
hold off;