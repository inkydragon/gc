# Advanced list operations
numbers = [5, 2, 8, 1, 9, 3]
print("Original:", numbers)

# Basic operations
print("sorted:", sort([5, 2, 8, 1, 9, 3]))
print("reversed:", reverse([1, 2, 3, 4, 5]))
print("sum:", sum(numbers))
print("len:", len(numbers))

# First and last
print("first:", first(numbers))
print("last:", last(numbers))

# Contains
print("contains 8:", contains(numbers, 8))
print("contains 100:", contains(numbers, 100))

# Unique
print("unique:", unique([1, 2, 2, 3, 3, 3]))

# Range
print("range(5):", range(5))
print("range(1,5):", range(1, 5))

# Append
nums2 = [1, 2, 3]
append(nums2, 4)
print("after append:", nums2)

# 高阶函数 (新内置函数)
print("")
print("=== 高阶函数 (内置) ===")
nums = [1, 2, 3, 4, 5]
print("map x*2:", map((x) => x * 2, nums))
print("filter 偶数:", filter((x) => x % 2 == 0, nums))
print("reduce 求和:", reduce((a, b) => a + b, nums, 0))
