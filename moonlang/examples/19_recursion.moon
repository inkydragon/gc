# Recursion
function factorial(n):
    if n <= 1:
        return 1
    end
    return n * factorial(n - 1)
end

print("factorial(5) =", factorial(5))  # 120
print("factorial(10) =", factorial(10))  # 3628800
