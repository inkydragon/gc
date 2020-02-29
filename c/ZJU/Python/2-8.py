f = lambda a,b: int(str(a), b)
print(f(*map(int, input().split(','))))