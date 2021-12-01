%% Q1
clear,
year0=[1790 1800 1810 1820 1830 1840 1850 1860 1870 1880 1890 1900 1910 1920 1930 1940 1950 1960 1970 1980 1990];
population0=[3.9 5.3 7.2 9.6 12.9 17.1 23.2 31.4 38.6 50.2 62.9 76.0 92.0 106.5 123.2 131.7 150.7 179.3 204.0 226.5 251.4];
year=1790:5:1990;

peo_num_1=interp1(year0, population0, year);
peo_num_2=spline(year0, population0, year);

subplot(2,1,1),plot(year0,population0,'r +',year,peo_num_1,'b -'),
title('分段线性插值')
subplot(2,1,2),plot(year0,population0,'r +',year,peo_num_2,'g -.'),
title('三次样条插值')
interp1_ans=interp1(year0, population0, [1965 1985])
spline_ans=spline(year0, population0, [1965 1985])