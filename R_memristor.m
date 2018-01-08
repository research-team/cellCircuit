u=0.8;
a=-86.2E-7;
i0=74.9E-7;
tau=-342;
t=linspace(0,300);
i=i0+a*exp(t./tau);
r=abs(u./i)
plot(t,r);