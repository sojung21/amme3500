% Q4c. Simulating the model response

d = 0.127;
t = linspace(0,3,2500);   % [s]
v = 0.1322;

y = 0.03*(...
    superimpose_this(v*pi/d, t) +...
    1/3*superimpose_this(v*3*pi/d, t) +...
	1/5*superimpose_this(v*5*pi/d, t) +...
    1/7*superimpose_this(v*7*pi/d, t));

plot(t,y);
xlabel('Time (s)');
ylabel('Car height (m)');