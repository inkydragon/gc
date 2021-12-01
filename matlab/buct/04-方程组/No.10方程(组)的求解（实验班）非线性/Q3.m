%% Q3
clear
fplot(@Q3_f,[0 pi/2],'r -')

[times,Lm]=Newt_equ(@Q3_df,@Q3_d2f,0.5,30,10-5)
