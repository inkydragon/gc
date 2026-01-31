# Fibonacci benchmark
function fib(n):
    if n <= 1:
        return n
    end
    return fib(n - 1) + fib(n - 2)
end

print("=== Fibonacci Benchmark ===")

start = time()
result = fib(30)
elapsed = time() - start

print("fib(30) =", result)
print("Time:", elapsed, "seconds")
