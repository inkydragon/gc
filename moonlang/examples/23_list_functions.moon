# List functions
numbers = [3, 1, 4, 1, 5]
print("Original:", numbers)

append(numbers, 9)
print("After append(9):", numbers)

print("sorted:", sort([3,1,4,1,5,9]))
print("sum:", sum([3,1,4,1,5,9]))
print("contains 4:", contains(numbers, 4))
print("first:", first(numbers))
print("last:", last(numbers))
print("unique:", unique([1,2,2,3,3,3]))
print("range(5):", range(5))
