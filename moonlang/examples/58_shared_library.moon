# Shared library example
# Compile: moonc mylib.moon --shared -o mylib.dll

# Exported functions - can be called externally
export function add(a, b):
    return a + b
end

export function multiply(a, b):
    return a * b
end

export function greet(name):
    return "Hello, " + name + "!"
end

# Internal function - not exported
function helper():
    return 42
end

# Test locally
print("Testing exports:")
print("add(3, 4) =", add(3, 4))
print("multiply(5, 6) =", multiply(5, 6))
print("greet('World') =", greet("World"))
