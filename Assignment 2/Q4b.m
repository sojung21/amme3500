% Q4b. Bode Plot

omega = 0.1:0.5:10000;

kd = 5000;    % [N/m]
ks = 20000;     % [N/m]
kw = 180000;      % [Ns/m]

mc = 1400;      % [kg]
mw = 12;        % [kg]

G = tf([kw*kd, kw*ks], ...
    [mc*mw, ...
    mw*kd + mc*kd, ...
    mw*ks + mc*kw + mc*ks, ...
    kd*kw, ...
    ks*kw]);

bode(G);
figure;

N_R = ks*kw;
N_I = (kd*kw)*omega;
D_R = mc*mw*(omega.^4) - (ks*mc+kw*mc+ks*mw)*(omega.^2) + ks*kw;
D_I = kd*kw*(omega.^1) - (kd*mc+kd*mw)*(omega.^3);

M = sqrt((N_R.*D_R + N_I.*D_I).^2 + (-N_R.*D_I+N_I.*D_R).^2)./(D_R.^2 + D_I.^2);
phi = atand(N_I./N_R);

semilogx(omega, 20*log10(M));
figure;
semilogx(omega, phi);


