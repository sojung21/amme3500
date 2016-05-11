
%% ASSUMPTIONS

% Two wheeled-robot
% Negligible mass of robot
% High gear ratio between motor and wheel 
%

%% INPUTS

IC = [0, 0];    % Instantaneous center as an [X, Y] coordinate [m]
r_P = 1;        % Path radius [m]

r = 0.05;       % Wheel radius [m]
L = 0.1;        % Distance between contact points of L & R wheel [m]

v_P = 1;        % Robot (path) velocity [m/s]

%% V_L & V_R

w = v_P/r_P;    % Robot's angular velocity about IC [rad/s]

v_L = w*(r_P-(L/2)); % Linear velocity of wheel closest to IC [m/s]
v_R = w*(r_P+(L/2)); % Linear velocity of wheel furthest from IC [m/s]

w_L = v_L/r;    % Angular velocity of wheel closest to IC [rad/s]
w_R = v_R/r;    % Angular velocity of wheel furthest from IC [rad/s]


%% SIMULATION

s= tf('s');
G = 23.05/(0.12*s +1);
T = feedback(G,1);
opt = stepDataOptions('StepAmplitude',w_L);
step(T,opt);