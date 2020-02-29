# f = lambda y: sorted(filter(lambda x:x, y))
# print('->'.join(f(input().split(' '))))
print('->'.join(sorted(map(str,map(int, input().split(' '))))))

# 4 2 8
# 2->4->8
# 1 -9 0
# -9->0->1
# 3 2 1
# 1->2->3
