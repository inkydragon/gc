def sum_dig_pow(a, b): # range(a, b + 1) will be studied by the function
    fn = lambda g:reduce(lambda y,x: y+int(str(g)[x])**(x+1),range(0, len(str(g))), 0) == g
    return filter(fn, range(a, b+1))

#sum_dig_pow(1, 10)
