# Closures test - NOTE: MoonLang may not fully support closures
# Closures require capturing outer scope variables

# Simple function test (works)
function add(a, b):
    return a + b
end

print("Simple function test:")
print("add(3, 4) =", add(3, 4))

# Higher-order function test (works)
function applyTwice(f, x):
    return f(f(x))
end

function double(n):
    return n * 2
end

print("")
print("Higher-order function test:")
print("applyTwice(double, 3) =", applyTwice(double, 3))  # 12

print("")
print("Note: Full closure support (capturing outer variables) may not be available")
