# Full Closure Support Test
# Tests for capturing outer scope variables in lambda expressions

# Test 1: Simple capture
print("=== Test 1: Simple capture ===")
x = 10
add_x = (y) => x + y
print("x=10, add_x(5) =", add_x(5))  # Expected: 15

# Test 2: Multiple variable capture
print("")
print("=== Test 2: Multiple variable capture ===")
a = 1
b = 2
sum_ab = (c) => a + b + c
print("a=1, b=2, sum_ab(3) =", sum_ab(3))  # Expected: 6

# Test 3: Closure with map/filter
print("")
print("=== Test 3: Closure with map ===")
multiplier = 3
nums = [1, 2, 3, 4, 5]
result = map((n) => n * multiplier, nums)
print("multiplier=3, map result:", result)  # Expected: [3, 6, 9, 12, 15]

# Test 4: Filter with closure
print("")
print("=== Test 4: Filter with closure ===")
threshold = 3
nums2 = [1, 2, 3, 4, 5]
filtered = filter((n) => n > threshold, nums2)
print("threshold=3, filtered:", filtered)  # Expected: [4, 5]

# Test 5: Factory function (makeAdder)
print("")
print("=== Test 5: makeAdder factory ===")
function makeAdder(n):
    return (x) => x + n
end

add5 = makeAdder(5)
add10 = makeAdder(10)
print("add5(3) =", add5(3))   # Expected: 8
print("add10(3) =", add10(3)) # Expected: 13

# Test 6: Closure in reduce
print("")
print("=== Test 6: Reduce with closure ===")
initial_offset = 100
numbers = [1, 2, 3, 4, 5]
total = reduce((acc, n) => acc + n, numbers, initial_offset)
print("initial_offset=100, reduce result:", total)  # Expected: 115

# Test 7: String closure
print("")
print("=== Test 7: String closure ===")
prefix = "Hello, "
greet = (name) => prefix + name
print(greet("World"))  # Expected: Hello, World
print(greet("Moon"))   # Expected: Hello, Moon

print("")
print("=== All closure tests completed ===")
