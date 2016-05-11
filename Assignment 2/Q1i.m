% Q1i. Step response for PD system

clc; clear; 

J = 5;
c = 0.7;
zeta = 0.6901;  % for <5% OS
K_d = 39.3;
K = 167.9832; 
omega = sqrt(K/J);
T_s = -log(0.02*sqrt(1-zeta^2)) / (zeta*omega); % 
T_s_simple = 4/(zeta*omega);  % 

s = tf('s');
G_noW = (K + K_d*s)/(J*s^2 + (c+K_d)*s + K);
stepplot(G_noW, 3);
figure;
pzmap(G_noW);
grid on
