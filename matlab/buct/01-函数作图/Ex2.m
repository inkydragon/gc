%% Q1
clear;

fplot(@(x)[tan(x),sin(x),cos(x)],[-2*pi,2*pi,-4,4])
legend('tan(x)','sin(x)','cos(x)')
