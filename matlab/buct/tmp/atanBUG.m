% z = cplxgrid(20)
% cplxmap(z, atan(z))
atanh

a=-5:0.1:5;
b=-5:0.1:5;
[aa,bb]=meshgrid(a,b); 

c=exp(aa).*cos(bb); %%实部
d=exp(aa).*sin(bb);%%虚部

subplot(1,2,1);
surf(aa,bb,c,'LineStyle','none');

subplot(1,2,2);
surf(aa,bb,d,'LineStyle','none');
