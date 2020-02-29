# prime = lambda n: 2 in [m, pow(2,n,n)]
# https://stackoverflow.com/a/15285588/10250520
def prime(n):
    if n == 2 or n == 3:    return True
    if n < 2  or n%2 == 0:  return False
    if n < 9:               return True
    if n%3 == 0:            return False
    r = int(n**0.5)
    f = 5
    while f <= r:
        if n%f     == 0: return False
        if n%(f+2) == 0: return False
        f +=6
    return True

PrimeSum = lambda m,n: sum(filter(prime, range(m,n+1)))
# ------------------
m,n=input().split()
m=int(m)
n=int(n)
print(PrimeSum(m,n))
#< 1 10
#> 17