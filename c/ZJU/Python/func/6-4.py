def fib(n, a=1, b=1):
    if n: 
        return fib(n-1, b, a+b)
    else: 
        return a

def PrintFN(m, n):
    list, i = ([], 1)
    while ( fib(i) <= n ):
        if m <= fib(i): list.append(fib(i))
        i += 1
    return list

# --------------------------
m, n, i = input().split()
n = int(n)
m = int(m)
i = int(i)
b = fib(i)
print("fib({0}) = {1}".format(i, b))
fiblist = PrintFN(m, n)
print(len(fiblist))
#< 20 100 6
#> fib(6) = 13
#> 4