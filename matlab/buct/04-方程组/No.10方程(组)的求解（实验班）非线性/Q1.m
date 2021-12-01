%% Q1
clear
x=-2:0.1:1;
y=Q1_f1(x);
y2=x-x;
plot(x,y,'r -',x,y2)

[Root_newton1,times1]=newton1(@Q1_f1,@Q1_df1,2,50,1e-6);
fprintf('迭代了%2.0d次,找到的解为%10.6f\n',times1,vpa(Root_newton1))
[Root_newton2,times2]=newton2(@Q1_f1,-2,0,50,1e-6);
fprintf('迭代了%2.0d次,找到的解为%10.6f\n',times2,vpa(Root_newton2))
