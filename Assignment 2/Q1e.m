% Q1e. Step response of P system

J = 5;  % [kgm^2]
c = 0.7;    % [Nms]
K = 0.05;

s = tf('s');

G = K/(J*s^2 + c*s + K); % No disturbance

% rlocus(G);
% figure
% stepplot(feedback(G,1));