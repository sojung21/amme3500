%% Root Locus Method for Lab 3 Crane Control

pmr = 0.095;
mp = 0.024;
Lr = 0.085;
Lp = 0.129;
Jr = 5.7*10^-5;
Jp = 1.8*10^-4;
Kt = 0.042;
Rm = 8.4;
Dr = 0.0015;
Dp = 0.0005;
g = 9.81;

tau_coef = Kt/Rm;
JT = Jp*mp*Lr^2 + Jr*Jp + 0.25*Jr*mp*Lp^2;

A = -(Jp+0.25*mp*Lp^2)*Dr/JT;
B = 0.5*mp*Lp*Lr*Dp/JT;
C = 0.25*mp^2*Lp^2*Lr*g/JT;
D = tau_coef*(Jp + 0.25*mp*Lp^2)/JT;

E = 0.5*mp*Lp*Lr*Dr/JT;
F = -(Jr+mp*Lr^2)*Dp/JT;
G = -0.5*mp*Lp*g*(Jr+mp*Lr^2)/JT;
H = 0.5*mp*Lp*Lr*tau_coef/JT;

s = tf('s');
UC_OL = (D*s^2 + (B*H-D*F)*s + C*H - D*G)/(s^4 - (F+A)*s^3 - (G-A*F+B*E)*s^2 + (A*G-C*E)*s);
% step(UC_OL); % Ramp response
% step(feedback(UC_OL,1)); % Settling time of 4.11s when K=1


%% DESIGN FOR OVERSHOOT

OS = 5; % [%]
zeta = -log(OS/100)/sqrt(pi^2 + log(OS/100)^2);
phi = acosd(zeta); % [deg]

% rlocus(UC_OL);
% sgrid(zeta,0);

% Current dominant pole location
sigma = 4.68;
omega_d = 4.91;
T_s = 4/sigma;
K = 0.825;
UC_CL = feedback(UC_OL,K);
% step(UC_CL); % Settling time of 2.69s for K at operating point

% OL Poles & Zeros
P1 = 7.72;
P2 = 0;
P3_R = 1.79;
P3_I = 7.67;
Z1_R = 1.55;
Z1_I = 9.58;

%% SETTLING TIME

% Desired dominant pole location
sigma = pi/(0.5*T_s); % 7.3513
omega_d = sigma*tand(phi); % 7.7093

% Angle contribution
theta_P1 = atand(omega_d/(P1-sigma));
theta_P2 = 180 - atand(omega_d/sigma); 
theta_P3 = 180 - atand((omega_d-P3_I)/(sigma-P3_R));
theta_P3_conj = 180 - atand((sigma-P3_R)/(P3_I + omega_d));
theta_Z1 = 270 - atand((Z1_I-omega_d)/(sigma-Z1_R));
theta_Z1_conj = 180 - atand((sigma-Z1_R)/(Z1_I + omega_d));

%% Compensating D zero
theta_Z =  theta_P1 + theta_P2 + theta_P3 - theta_Z1 + theta_P3_conj - theta_Z1_conj + 180;
Z = (omega_d/tand(theta_Z)) + sigma;

PD = (s+Z)*UC_OL;
rlocus(PD);
sgrid(zeta,0);


     