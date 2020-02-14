
function fib(n)
    FIVE = sqrt(BigFloat(5))
    ϕ = (1 + FIVE)/2
    return Int(floor(ϕ^n/FIVE + 0.5))
end

function fib_BinaryRec(n)
    fib_BinaryRec(BigInt(n))
end

function fib_BinaryRec(n::BigInt)
    if n == 0
        return BigInt(0)
    elseif n == 1
        return BigInt(1)
    else
        return fib_BinaryRec(n-1) + fib_BinaryRec(n-2)
    end
end

function fin_LinearRec(n::BigInt)
    if n == 0
        return 0, 0
    else
        fin_n, prev = fib_BinaryRec(n-1)
        return fin_n+prev, fin_n
    end
end

function fib_DP(n)
    f = BigInt(0)
    g = BigInt(1)
    while n > 0
        n -= 1
        f = g
        g += f
    end
    return g
end