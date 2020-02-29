f = lambda n: pow(-1,n) * (n+1) / (2*n+1)
print("{:.3f}".format(sum([f(i) for i in range(int(input()))])))