s = tf('s');
tau = 0.12;
kss = 23.05;
kp = 1/(tau*kss);
G = kp*kss/(tau*s^2 + s + kp*kss);
G = kss/(tau*s +1);
step(feedback(G,kp))
% 
% time = u_in.time;
% u = u_in.signals.values;
% x = x_out.signals.values;
% plot(time, u, time, x);