ts=0:0.1:100;
x0=[0.2,0.8];
[t,x]=ode45('ill_fun',ts,x0);

%%%%  plot the curve of the solution
plot3(t,x(:,1),x(:,2),'r -')
xlabel('time')
ylabel('the percentage of ill people')
zlabel('the percentage of susceptible people')
