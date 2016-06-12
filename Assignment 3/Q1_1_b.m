m=5;
d=0.01;
k=10;
s=tf('s');
G=1/(m*s^2 + d*s + k);
bode(G);
hold on
k2 = 25;
G2=1/(m*s^2 + d*s + k2); 
bode(G2);