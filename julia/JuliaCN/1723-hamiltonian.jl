
u = ones(2)
b = u
i = 4
println("[$i] u=$u; b=$b")

function test(i, u, b)
    while i > 0
        # global i, u, b
        println("[$i] u=$u; b=$b")

        b = u
        u .+= 1
        i -= 1
    end
    u, b
end

test(i, u, b) |> println
