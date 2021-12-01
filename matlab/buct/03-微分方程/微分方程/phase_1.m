ts=0:0.5:100;
x0=[0.2,0.8];
[t,x2]=ode45('ill_fun',ts,x0);

%%%%  plot the curve of the solution
plot(t,x2(:,1),'r -')
%plot(t,x2(:,2),'b -')
xlabel('time')
ylabel('the percentage of ill people')
%ylabel('the percentage of susceptible people')
