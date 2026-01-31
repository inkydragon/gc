# 测试新增内置函数

print("=== 测试 map ===")
nums = [1, 2, 3, 4, 5]
doubled = map((x) => x * 2, nums)
print("原始:", nums)
print("map x*2:", doubled)

print("")
print("=== 测试 filter ===")
evens = filter((x) => x % 2 == 0, nums)
print("原始:", nums)
print("filter 偶数:", evens)

print("")
print("=== 测试 reduce ===")
total = reduce((acc, x) => acc + x, nums, 0)
print("原始:", nums)
print("reduce 求和:", total)

print("")
print("=== 测试 pad_left ===")
s1 = pad_left("42", 6, "0")
print("pad_left('42', 6, '0'):", s1)

print("")
print("=== 测试 pad_right ===")
s2 = pad_right("Hi", 6, ".")
print("pad_right('Hi', 6, '.'):", s2)

print("")
print("=== 全部测试完成 ===")
