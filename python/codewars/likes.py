'''
def likes(names):
    return {
    0: "no one likes this",
    1: lambda names: "%s likes this" % names[0],
    #2: "%s and %s like this" % (names[0], names[1]),
    #3: "%s, %s and %s like this" % (names[0], names[1], names[2]),
    #4: "%s, %s and %d others like this" % (names[0], names[1], len(names)-2),
    }[0]#(names)
    #len(names) *(not len(names)/4) + 4* (not not len(names)/4)
'''

print "len len%4 len/4"
for len in range(0,20):
    print "%3d %3d  %3d %3d" % (len, len%5, len/4, len *(not len/4) + 4* (not not len/4))