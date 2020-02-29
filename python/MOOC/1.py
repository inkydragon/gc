ipt = input()
ln  = ipt.split(' ') # 空格分割
y, m, d = list(map(int, ln)) # 转成 int 数组

#--- 公式
y0 = int( y - (14 - m ) / 12            )
x  = int( y0 + y0/4 - y0/100 + y0/400   )
m0 = int( m + 12 * (14 - m)/12 - 2      )
d0 = int( (d + x + (31*m0)/12) % 7      )
print(d0)

#< 2000 02 14
#> 1