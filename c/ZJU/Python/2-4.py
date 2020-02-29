fn = lambda a, n: sum([int(str(a)*i) for i in range(1,n+1)])
print("s =", fn(*map(int, input().split())))