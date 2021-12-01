from fractions import gcd
import random
from random import randrange
def solution(a):
    return reduce(gcd, a) * len(a)





print solution([2, 2, 2])
print solution([6, 9, 21])
print solution([1, 2, 3])
print solution([1, 1, 2])
print solution([3, 5, 9])
print solution([71, 37, 3])
print solution([123, 645, 439])

print "----------------"
print solution ([1, 21, 55])
print solution ([3, 13, 23, 7, 83])
print solution ([4, 16, 24])
print solution ([30, 12])
print solution ([60, 12, 96, 48, 60, 24, 72, 36, 72, 72, 48])
print solution ([71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71, 71])
print solution ([11, 22])
print solution ([9])
print "----------------"
print solution ([3, 31, 113, 499, 1009, 1987, 9973, 10007, 104759, 1299899, 15487469]),' ', 1*11

print solution (map(lambda x:x*randrange(2, 101, 2), range(1,5))+[2] ),' ', 2*5
print solution (map(lambda x:x*randrange(2, 101, 2), range(1,7))+[2] ),' ', 2*7
print solution (map(lambda x:x*randrange(3, 3*35+1, 3), range(1,5))+[3] ),' ', 3*5
print solution (map(lambda x:x*randrange(3, 3*35+1, 3), range(1,7))+[3] ),' ', 3*7


print solution (map(lambda x:x*randrange(11*2000, 11*4000+1, 11), range(1,130))+[11]),' ', 11*130
print solution (map(lambda x:x*randrange(13*2000, 13*4000+1, 13), range(1,170))+[13]),' ', 13*170