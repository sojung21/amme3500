% Q4c. Modelling the road height

clc; clear all; close all;

x = linspace(0,1);
d = 0.127;

r = 0.03 * (...
    sin(pi*x/d)...
    + (1/3)*sin(3*pi*x/d)...
    + (1/5)*sin(5*pi*x/d)...
    + (1/7)*sin(7*pi*x/d)...
    );

a = 0.03 * sin(pi*x/d);
b = 0.03 * (1/3)*sin(3*pi*x/d);
c = 0.03 * (1/5)*sin(5*pi*x/d);
d = 0.03 * (1/7)*sin(7*pi*x/d);

plot(x,r,x,a,x,b,x,c,x,d);
legend('Total','1', '3', '5', '7');
xlabel('Distance (m)');
ylabel('Road height');