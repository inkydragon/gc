ts=0:0.5:400;
x0=[0.01,0];

%%%%%     solve the initial problem
%[t,x]=ode23('logi_fun',ts,x0);
[t,x]=ode23('logi_fun',ts,x0);
%%%%  plot the curve of the solution
plot(t,x(:,1),'r -')
xlabel('time')
ylabel('the rate of illness')