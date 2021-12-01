ts=0:0.5:600;
x0=[0.02,0.98];

%%%%%     solve the initial problem
%[t,x]=ode23('logi_fun',ts,x0);
[t,x1]=ode45('ill_fun',ts,x0);

x0=[0.2,0.8];
[t,x2]=ode45('ill_fun',ts,x0);
x0=[0.5,0.5];
[t,x3]=ode45('ill_fun',ts,x0);
x0=[0.7,0.3];
[t,x4]=ode45('ill_fun',ts,x0);
%%%%  plot the curve of the solution
plot(x1(:,2),x1(:,1),'r -',x2(:,2),x2(:,1),'g +',x3(:,2),x3(:,1),'b *',x4(:,2),x4(:,1),'m o')
xlabel('the percentage of susceptible')
ylabel('the percentage of ill people')
title('graphic of modified SIR model')
gtext('[0.02,0.98]'),gtext('[0.2,0.8]'),gtext('[0.5,0.5]'),gtext('[0.7,0.3]')