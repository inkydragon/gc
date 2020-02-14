using MLStyle

ex = :(
    @column for k in 1:n
        p = 2^(k-1)
        control(k, n+1:n+m => U^p)
    end
)

ex2 = :(@column())

@match ex begin
    :(@column $linenumber $block) => block
    _ => :err
end
# :(for k = 1:n
#       #= REPL[68]:3 =#
#       p = 2 ^ (k - 1)
#       #= REPL[68]:4 =#
#       control(k, n + 1:n + m => U ^ p)
#   end)

name = Symbol("@column")
@match ex begin
   Expr(:macrocall, $name, _) => true
end
# err
