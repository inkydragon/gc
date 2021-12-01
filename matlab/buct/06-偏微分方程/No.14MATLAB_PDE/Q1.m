%% Q1
clear;
x=-800:1:800;
t=0:0.05:8;
m=0;

solu=pdepe(m,@mp,@mpic,@mpbc,x,t);
waterfall(x,t,solu(:,:,1))