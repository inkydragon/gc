%% Q2
clear
n=20;  
tol = 1e-6;
x0 = [1, 1]';
x02 = [0.5, 0.5]';

[i_1,res_1]=Newt_equ(@Q2_f,@Q2_df,x0,n,tol);
fprintf('迭代了%2.0d次,找到的解为[%5.3f,%5.3f]\n',i_1,res_1(1),res_1(2))
[i_2,res_2]=Newt_equ(@Q2_f2,@Q2_df2,x02,n,tol);
fprintf('迭代了%2.0d次,找到的解为[%5.3f,%5.3f]\n',i_1,res_2(1),res_2(2))