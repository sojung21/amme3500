clear; clc;

r = 0.012;  % [m]
m = 0.0075;   % [kg]
J = 2*m*r^2/5;
K_d = 3.05*10^-4;   % [Ns/m]
K_p = 1.65*10^-2; % [N/m]

OS = 5; % [%]
zeta = -log(OS/100)/sqrt(pi^2 + log(OS/100)^2);
phi = acosd(zeta); % [deg]

s = tf('s');

%% UNCOMPENSATED SYSTEM

UC = 100/((s+100)*(J*s^2 + K_d*s + K_p));

% grid on
% stepplot(UC, 0.25);
% figure;
rlocus(UC);
% sgrid(zeta,0)

P1 = 59.03;
P2 = 100;
P3 = 647;
K = 0.0161;
T_s = 0.066;

%% COMPENSATED SYSTEM

%% Reduce T_s by half
sigma = pi/(0.5*T_s);
omega_d = sigma*tand(phi);

theta_P1 = 90 + atand((sigma-P1)/(omega_d)); % Desired dominant pole upper left of pole
theta_P2 = 90 + atand((sigma-P2)/(omega_d)); % Desired dominant pole upper left of pole
theta_P3 = atand(omega_d/(P3-sigma)); % Desired dominant pole upper right of pole

%% Compensating D zero
theta_Z =  theta_P1 + theta_P2 + theta_P3 - 180;
Z = (omega_d/tand(theta_Z)) + sigma;

PD = (s+Z)/((s+100)*(J*s^2 + K_d*s + K_p));
% rlocus(PD);  
% sgrid(zeta,0);
K = 0.0119;
CL_PD = feedback(K*PD,1);
% stepplot(CL_PD,0.1);

%% Compensating I zero
I=40;
PID = (s+I)*(s+Z)/(s*(s+100)*(J*s^2 + K_d*s + K_p));
% rlocus(PID);  
sgrid(zeta,0);
% sigma = 95.2;
% omega = 99.8;
K = 0.0119;
% figure;
CL_PID = feedback(K*PID,1);
% stepplot(CL_PID);

%% Calculate gains

PID_K_d = K;
PID_K_p = (Z+I)*PID_K_d;
PID_K_i = (Z*I)*PID_K_d;

