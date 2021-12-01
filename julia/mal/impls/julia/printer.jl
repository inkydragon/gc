# printer.jl

# fallback
Base.show(io::IO, m::MalType) = print(io, m.val)

## Primitive Types
Base.show(io::IO, m::MalStr) = print(io, "\"$(m.val)\"")
Base.show(io::IO, m::MalNil) = print(io, "nil")
Base.show(io::IO, m::MalComment) = nothing
Base.show(io::IO, m::MalKeyword) = print(io, repr(m.val))
Base.show(io::IO, m::MalDeref) = print(io, "(deref $(m.val))")
Base.show(io::IO, m::MalFunc) = print(io, "#<function>")
Base.show(io::IO, m::MalNothing) = nothing

## Composite Types
function rec_ds_show(
        io::IO, 
        m::MalListLike,
        LP::String,
        RP::String
    )
    print(io, LP)
    join(io, m.val, " ")
    print(io, RP)
end
Base.show(io::IO, m::MalList) = rec_ds_show(io, m, "(", ")")
Base.show(io::IO, m::MalVec)  = rec_ds_show(io, m, "[", "]")
function Base.show(io::IO, m::MalHash)
    print(io, "{")
    join(io, ["$k $v" for (k,v) in m.val], " ")
    print(io, "}")
end

Base.show(io::IO, m::MalQuote) =
    print(io, "(quote $(m.val))")
Base.show(io::IO, m::MalUnquote) =
    print(io, "(unquote $(m.val))")
Base.show(io::IO, m::MalQuasiQuote) =
    print(io, "(quasiquote $(m.val))")
Base.show(io::IO, m::MalSpliceUnquote) =
    print(io, "(splice-unquote $(m.val))")

Base.show(io::IO, m::MalMetadata) =
    print(io, "(with-meta $(m.val) $(m.meta))")

pr_str(m::MalType, print_readably::Bool=true) =
    print_readably ? "$m" : unescape_string("$m")
# pr_str(s::MalStr, print_readably::Bool=true) =
#     print_readably ? s.val : unescape_string(s.val)