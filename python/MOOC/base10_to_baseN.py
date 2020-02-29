def f(n, x):
    # n为待转换的十进制数，x为机制，取值为 2-16
    a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'b', 'C', 'D', 'E', 'F']
    b = []
    while True:
        s = n//x  # 商
        y = n % x  # 余数
        b = b+[y]
        if s == 0:
            break
        n = s
    b.reverse()
    for i in b:
        print(a[i], end='')

f(*map(int, input().split(' ')))
