fn = lambda a, n: sum([int(str(a)*i) for i in range(1,n+1)])
# def fn(a, n):
#     sum = 0
#     for i in range(1,n+1):
#         item = str(a) * i
#         sum += int(item)
#     return sum
# --------------------------
a, b = input().split()
s = fn(int(a), int(b))
print(s)
#< 2 3
#> 246