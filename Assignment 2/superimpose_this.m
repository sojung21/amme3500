% Q4c. Function to calculate y(t) contributions as a function of omega

function [this] = superimpose_this(omega_expression, time_vector)

omega = omega_expression;
t = time_vector;

kd = 5000;    % [N/m]
ks = 20000;     % [N/m]
kw = 180000;      % [Ns/m]

mc = 1400;      % [kg]
mw = 12;        % [kg]

N_R = ks*kw;
N_I = (kd*kw)*omega;
D_R = mc*mw*(omega.^4) - (ks*mc+kw*mc+ks*mw)*(omega.^2) + ks*kw;
D_I = kd*kw*(omega.^1) - (kd*mc+kd*mw)*(omega.^3);

M = sqrt((N_R.*D_R + N_I.*D_I).^2 + (-N_R.*D_I+N_I.*D_R).^2)./(D_R.^2 + D_I.^2);
phi = atand(N_I./N_R);

this = M*sin(omega*t + phi);

