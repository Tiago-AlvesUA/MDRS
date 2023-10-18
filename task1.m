clc;
clear all;

Num = 20;
P = 100000;
alfa = 0.1;
rate = 1800;
f = 1000000;
C = [10 20 30 40];

APD = zeros(4, Num);

for i = 1:Num
    for j = 1:4
        [~, APD(j, i), ~, ~] = Simulator1(rate, C(j), f, P);
    end
end

mAPD = zeros(1, 4);
tAPD = zeros(1, 4);

for i = 1:4
    mAPD(i) = mean(APD(i));
    tAPD(i) = norminv(1 - alfa / 2) * sqrt(var(APD(i)) / Num);
end

figure(1);
bar(C, mAPD);
hold on

% Add error bars using errorbar
er = errorbar(C, mAPD, tAPD);
er.Color = [0 0 0]; 
er.LineStyle = 'none';

hold off;

xlabel('C (Mbps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');
