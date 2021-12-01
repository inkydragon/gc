%% Q1
clear;
    
x1=-709:0.1:-705;
f1=exp(-x1).*sin(pi*power(x1,3));
subplot(3,1,1),plot(x1,f1,'r -')
subplot(3,1,2),fplot(@(x1)[exp(-x1).*sin(pi*x1.^3)],[-709,-705]);
subplot(3,1,3),fplot(@(x2)[sin(x2)./x2],[-20,20])


