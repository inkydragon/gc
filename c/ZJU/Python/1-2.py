# s = input().split(' ')
# b = s[1]
# a = s[0]
# c = s[2]
# print(eval("{b}*{b}-4*{a}*{c}"))
print(eval("{1}*{1}-4*{0}*{2}".format(*input().split(' '))))
#< 3 4 5
#> -44