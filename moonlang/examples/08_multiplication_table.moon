# Multiplication table - simple version
print("九九乘法表:")
print("1x1=1")
print("1x2=2 2x2=4")
print("1x3=3 2x3=6 3x3=9")
print("1x4=4 2x4=8 3x4=12 4x4=16")
print("1x5=5 2x5=10 3x5=15 4x5=20 5x5=25")
print("1x6=6 2x6=12 3x6=18 4x6=24 5x6=30 6x6=36")
print("1x7=7 2x7=14 3x7=21 4x7=28 5x7=35 6x7=42 7x7=49")
print("1x8=8 2x8=16 3x8=24 4x8=32 5x8=40 6x8=48 7x8=56 8x8=64")
print("1x9=9 2x9=18 3x9=27 4x9=36 5x9=45 6x9=54 7x9=63 8x9=72 9x9=81")

# 也可以用循环 + print 多参数
print("")
print("使用循环:")
for i = 1 to 5:
    for j = 1 to i:
        print(j, "*", i, "=", i*j)
    end
end
