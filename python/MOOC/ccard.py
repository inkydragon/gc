ipt = int(input())
digits = [int(c) for c in str(ipt)]

acc1 = 0
acc2 = 0
for i in range(8):
    d = digits[i]
    if i % 2 == 1:  # 1,3,5,7
        acc1 += d  # 隔位相加
    else:  # 0,2,4,6,8
        d = d*2
        acc2 += d % 10 + int(d/10)
# 调试用
# print("acc1={}, ac2={}, sum={}".format(acc1, acc2, acc1+acc2))
if (acc1+acc2) % 10 == 0:
    print("有效")
else:
    print("无效")

#< 43589795
#> 有效
