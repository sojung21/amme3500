clc;

s = tf('s');

wn = 0.2; % [rad/s]
m = 10; % [kg]
Js = 0.4352; % [kg.m^2]
Jp = 9.083; % [kg.m^2]
k = wn^2*Jp; % [Nm]
d = 1*10^-3; % [Ns/m]

G = (Jp*s^2 + d*s + k)/(Js*Jp*s^4 + d*(Jp+Js)*s^3 + k*(Jp+Js)*s^2);
G = minreal(G);
% rlocus(G);
% [z, p, k] = zpkdata(G);
% syms s
% collect(tf2,s)

A = [0 1 0 0; -k/Js -d/Js k/Js d/Js; 0 0 0 1; k/Jp d/Jp -k/Jp -d/Jp];
B = [0; 1; 0; 0];
C = [1 0 0 0];

sys = ss(A,B,C,0);
% bode(sys);
sys_order = order(sys); % 4th order
c_det = det(ctrb(A,B)); % Non-zero determinant -> Controllable
o_det = det(obsv(A,C)); % Non-zero determinant -> Observable
z = zero(sys);
p = eig(A);

OS = 0.1; % [%]
zeta = -log(OS/100)/sqrt(pi^2 + log(OS/100)^2);
phi = acosd(zeta); % [deg]
T_s = 2.6; % [s]

% Desired dominant pole locations
sigma = pi/(T_s);
omega_d = sigma*tand(phi);

i = sqrt(-1);
p1 = -sigma + omega_d*i;
p2 = -sigma - omega_d*i;
p3 = -0.0001 + 0.2i; % To cancel zeros
p4 = -0.0001 - 0.2i; % To cancel zeros

K = place(A,B,[p1 p2 p3 p4]);
sys_cl = ss(A-B*K,B,C,0);
SS_error = 1+C*(A-B*K)^-1*B;
% step(sys_cl,3); 

% Add integral control

Aa = [0 1 0 0 0;
    -k/Js -d/Js k/Js d/Js 0; 
    0 0 0 1 0; 
    k/Jp d/Jp -k/Jp -d/Jp 0; 
    1 0 0 0 0];
Ba = [0; 1; 0; 0; 0];
Br = [0 ; 0 ; 0; 0; -1];
Ca = [1 0 0 0 0];

p5 = -10;
Ka = place(Aa,Ba,[p1,p2,p3,p4,p5]);

sys_cl_integral = ss(Aa-Ba*Ka,Br,Ca,0);
% step(sys_cl_integral);

% t=0:0.001:10;
% u = ones(size(t));
% x0 = [0 0 0 0 0];
% [yOut, tOut, xOut ]=lsim(sys_cl_integral,u,t,x0);
% figure; plot(t,yOut);
% torque = -Ka*xOut';
% figure; plot(t,torque)
% xlabel('Time (s)');
% ylabel('Torque (Nm)');


%% Q2.3

settling_time = 3.39;
ramp_seconds = ceil(settling_time);
M_size = 46*ramp_seconds;
u = ones(1,M_size);
amplitude = 1;

time_divisions = 2;
no_to_fill = ramp_seconds*time_divisions;
 for a = 1:46
     for j=1:no_to_fill
        u(1,(no_to_fill*a)-no_to_fill+j)=amplitude;
     end
     amplitude=amplitude+1;
 end
 
t=0:(1/time_divisions):(length(u)-1)/2;
x0 = [0 0 0 0 0];
[yOut, tOut, xOut ]=lsim(sys_cl_integral,u,t,x0);
figure; plot(t,yOut);
xlabel('Time (s)');
ylabel('Satellite position (deg)');
torque = -Ka*xOut';
figure; plot(t,torque)
xlabel('Time (s)');
ylabel('Torque (Nm)');
figure; plot(t,u);
xlabel('Time (s)');
ylabel('Reference (deg)');

