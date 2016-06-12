m_s = 0.65;
m_r = 0.42;
m_p = 10;
m_f = 100;
M_T = m_s + m_r + 2*m_p + m_f;

t = x_out.time;
x = x_out.signals.values;
v = v_out.signals.values;
a = a_out.signals.values;
m = m_out.signals.values;

plot(t,x,t,v,t,a);

F = 24;