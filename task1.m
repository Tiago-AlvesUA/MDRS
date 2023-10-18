clc;
clear all;

Num = 20;
P = 10000;
alfa = 0.1;
rate = 1800;
f = 1000000;
C = [10 20 30 40];

APD = zeros(4, Num);
mAPD = zeros(4, 1);
term = zeros(4, 1);

for i = 1:4
    for j = 1:Num
        [~, APD(i, j), ~, ~] = Simulator1(rate, C(i), f, P);
    end
    mAPD(i,1) = mean(APD(i,:));
    term(i,1) = norminv(1-alfa/2) * sqrt(var(APD(i,:)) / Num);
end
fprintf('APD C10 (%%) = %.2e +- %.2e\n',mAPD(1,1),term(1,1));
fprintf('APD C20 (%%) = %.2e +- %.2e\n',mAPD(2,1),term(2,1));
fprintf('APD C30 (%%) = %.2e +- %.2e\n',mAPD(3,1),term(3,1));
fprintf('APD C40 (%%) = %.2e +- %.2e\n',mAPD(4,1),term(4,1));

figure(1);
bar(C, mAPD);
hold on

er = errorbar(C, mAPD, term);
er.Color = [255 255 0];
er.LineStyle = 'none';

hold off;

xlabel('C (Mbps)');
ylabel('Average Packet Delay (ms)');
title('Average Packet Delay with Error Bars');
