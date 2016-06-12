%% PROPORTIONAL

clear all; close all; clc;

OS=5;           % [%]        
zeta=(-log(OS/100))/(sqrt(pi^2+log(OS/100)^2));
PM=atan(2*zeta/(sqrt(-2*zeta^2+sqrt(1+4*zeta^4))))*(180/pi);
PA=-180+PM; 

Iw = 0.52;      % [kgm^2]
Is = 0.4352;    % [kgm^2]
Kss = 20;       % [rad/V]
tau = 0.52;     % [s]
numerator = (Iw/Is)*(Kss/tau);                        
denominator = [1, 1/tau, 0]; 
G=tf(numerator,denominator);             

w=0.01:0.01:1000;         
[M,P]=bode(G,w);               
                

for i=1:1:length(P);                                          
    if P(i)-PA <= 0;            
        M=M(i); % Current OL magnitude                            
        K=1/M;  % Required gain  
        break                              
    end                                 
end                              

T=feedback(K*G,1);                 
% step(T,20);                            
% title(['Closed-Loop Step Response for K= ',num2str(K)]);
% figure;
% bode(G);
% title('Bode Plot for Uncompensated System');
% figure;
% bode(K*G);
% title('Bode Plot for Gain-Adjusted System');
% figure; step(feedback(G,1),20);

% LAG

PM = PM + 20;   % Compensate for phase angle contribution of compensator            
PA = -180+PM;  

K=K*10;                             % Improve steady-state error tenfold
                                    % NB. Type 1 system - K is proportional to Kv

[M,P]=bode(K*G,w);   

for j=1:1:length(P);                                          
    if P(i)- PA <= 0;          
        M=M(j);  % Current magnitude at phase angle                          
        wf=w(j); % Frequency at phase angle
        break                              
    end                                 
end  
                                    
wH=wf/10;                           % High frequency break of lag compensator (arbitrary)
wL=(wH/M);                          % Low frequency break of the lag compensator
num_c=[1 wH];                       
den_c=[1 wL];                        
Kc=wL/wH;                           % To yield Kv=1                                            
Gc=tf(Kc*num_c,den_c);                               
GcG=Gc*G;
T=feedback(GcG,1);                 
step(T)                            
title('Closed-Loop Step Response for Lag-Compensated System')

s=tf('s');                      
sGcG=s*GcG;                         
sGcG=minreal(sGcG);                 % Cancel common terms
Kv=dcgain(sGcG);                    

%% LEAD

Kv = 30;
sG=s*G;                            
sG=minreal(sG);                   
K=dcgain(Kv/sG);                
G=zpk(K*G);

Ts = 0.5;
wn=4/(zeta*Ts);
wBW=wn*sqrt((1-2*zeta^2)+sqrt(4*zeta^4-4*zeta^2+2)); % Required bandwidth

[M,P]=bode(G,w);                  
[Gm,Pm,Wcg,Wcp]=margin(G);      

Pc = PM - Pm;                       % Required phase contribution 

beta=(1-sin(Pc*pi/180))/(1+sin(Pc*pi/180));
Mc=1/sqrt(beta);                    % Compensator magnitude at peak of phase curve

for k=1:1:length(M);                
    if M(k)-(1/Mc)<=0;             
        wmax=w(k);                  % New phase margin frequency
        break                              
    end                               
end                                

wL=wmax*sqrt(beta);                 % Low frequency break of lead compensator
wH=wL/beta;                         % High frequency break of lead compensator
Kc=1/beta;                          % Gain of lead compensator

Gc=tf(Kc*[1 wL],[1 wH]);           
Gc=zpk(Gc);                       

Ge=G*Gc;                                                 
T=feedback(Ge,1);                 
step(T);
title('Correction Factor-Adjusted: OS=5, Ts= 0.5, Kv=30');

sGe=s*Ge;                          
sGe=minreal(sGe);                  
Kv=dcgain(sGe); 
