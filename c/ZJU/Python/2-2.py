f = lambda x: (x,x) if not x else (x,1/x)
print("f({:.1f}) = {:.1f}".format(*f(float(input()))))