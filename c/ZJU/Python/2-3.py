f = lambda x: x*0.53 if x<=50 else (x-50)*0.58 + 50*0.53
kw = float(input())
if kw > 0:
    print("cost = {:.2f}".format(f(kw)))
else:
    print("Invalid Value!")