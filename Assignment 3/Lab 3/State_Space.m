clc; clear all;

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

A_coef = -(Jp+0.25*mp*Lp^2)*Dr/JT;
B_coef = 0.5*mp*Lp*Lr*Dp/JT;
C_coef = 0.25*mp^2*Lp^2*Lr*g/JT;
D = tau_coef*(Jp + 0.25*mp*Lp^2)/JT;

E = 0.5*mp*Lp*Lr*Dr/JT;
F = -(Jr+mp*Lr^2)*Dp/JT;
G = -0.5*mp*Lp*g*(Jr+mp*Lr^2)/JT;
H = 0.5*mp*Lp*Lr*tau_coef/JT;

s = tf('s');
theta_on_U = (D*s^2 + (B_coef*H-D*F)*s + C_coef*H - D*G)/(s^4 - (F+A_coef)*s^3 - (G-A_coef*F+B_coef*E)*s^2 + (A_coef*G-C_coef*E)*s);
[z1, poles1, k1] = zpkdata(theta_on_U);  % All poles on LHS half-plane -> Stable
denom = s^2-F*s-G;
denom2 = denom*(s^2-A_coef*s);
alpha_on_U = ((D*E*s/denom2) + H/denom)/...
    (1-(E*s*(B_coef*s+C_coef))/denom2);
alpha_on_U = minreal(alpha_on_U); % All poles on LHS half-plane -> Stable
[z2, poles2, k2] = zpkdata(alpha_on_U);

%% State Space Matrices

A = [0 0 1 0; 0 0 0 1; 0 C_coef A_coef B_coef; 0 G E F];
B = [0; 0; D; H];
C = [1 0 0 0];

c_rank = rank(ctrb(A,B)); % Full rank
c_det = det(ctrb(A,B)); % Non-zero determinant -> Controllable
o_rank = rank(obsv(A,C)); % Full rank
o_det = det(obsv(A,C)); % Non-zero determinant -> Observable

OS = 1; % [%]
zeta = -log(OS/100)/sqrt(pi^2 + log(OS/100)^2);
phi = acosd(zeta); % [deg]
T_s = 0.7; % [s]
% Desired dominant pole locations
sigma = pi/(T_s);
omega_d = sigma*tand(phi);

i = sqrt(-1);
p1 = -sigma + omega_d*i;
p2 = -sigma - omega_d*i;
p3 = -1.54923272843930 + 9.57631072896759i; % To cancel zeros
p4 = -1.54923272843930 - 9.57631072896759i; % To cancel zeros

sys = ss(A,B,C,0);

K = place(A,B,[p1 p2 p3 p4]);
sys_cl = ss(A-B*K,B,C,0);
step(sys_cl); 

SS_error = 1+C*(A-B*K)^-1*B;