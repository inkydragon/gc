# Lambda expressions
square = (x) => x * x
print("square(5) =", square(5))  # 25

add = (a, b) => a + b
print("add(3, 4) =", add(3, 4))  # 7

# Lambda with higher-order function
function apply(f, x):
    return f(x)
end

result = apply((n) => n * n * n, 3)
print("cube of 3 =", result)  # 27
