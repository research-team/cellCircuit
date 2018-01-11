u=0.8;
a=-86.2E-7;
i0=74.9E-7;
tau=-342;
t=linspace(0,50);
i=i0+a*exp(t./tau);
r=abs(u./i);
plot(t,r);
rlog=log(r);
plot(t,rlog);
colorlog=(log(r)-log(7E5))/(log(5E8)-log(7E5))*255;
plot(t,colorlog);