from functools import reduce
from operator  import mul

prod = lambda   n: reduce(mul, range(1,n+1), 1)
term = lambda x,n: pow(-1,n) * pow(x,2*n) / prod(2*n) 

def funcos(eps, x):
    i = cos = 0
    while True:
        t = term(x,i)
        if abs(t) < eps: break
        cos += t
        i += 1
    return cos

# -----------------------
eps = float(input())
x = float(input())
value = funcos(eps, x)
print("cos({0}) = {1:.4f}".format(x, value))
#< 0.0001
#< -3.1
#> cos(-3.1) = -0.9991