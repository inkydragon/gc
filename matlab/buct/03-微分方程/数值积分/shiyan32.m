t=0:pi/10:pi/2;
z=weixing(t);
L1=4*trapz(t,z)
L2=4*quad('weixing',0,pi/2,1e-6)

