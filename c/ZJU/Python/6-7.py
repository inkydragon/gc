from itertools import permutations

n = int(input())
[print(''.join(t)) for t in permutations("1234567"[:n])]