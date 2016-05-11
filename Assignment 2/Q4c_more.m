% Q4c. Simulating the model response

d = 0.127;
t = linspace(0,1);   % [s]

y = 0.03*(...
    superimpose_this(10*pi/d, t) +...
    1/3*superimpose_this(30*pi/d, t) +...
	1/5*superimpose_this(50*pi/d, t) +...
    1/7*superimpose_this(70*pi/d, t));

plot(t,y);
xlabel('Time (s)');
ylabel('Car height (m)');