%% Q3
clear;
x=-10:0.05:10;
t=0:0.05:4;
m=0;

solu=pdepe(m,@mp3,@mpic3,@mpbc3,x,t);
waterfall(x,t,solu(:,:,1))