include("types.jl")
import Base.show

# fallback
Base.show(io::IO, m::MalType) = print(io, m.val)

## Primitive Types
Base.show(io::IO, m::MalStr) = print(io, "\"$(m.val)\"")
Base.show(io::IO, m::MalNil) = print(io, "nil")
Base.show(io::IO, m::MalComment) = nothing
Base.show(io::IO, m::MalDeref) = print(io, "(deref $(m.val))")

## Composite Types
function Base.show(io::IO, m::MalList)
    print(io, "(")
    join(io, m.val, " ")
    print(io, ")")
end
Base.show(io::IO, m::MalQuote) =
    print(io, "(quote $(m.val))")
Base.show(io::IO, m::MalUnquote) =
    print(io, "(unquote $(m.val))")
Base.show(io::IO, m::MalQuasiQuote) =
    print(io, "(quasiquote $(m.val))")
Base.show(io::IO, m::MalSpliceUnquote) =
    print(io, "(splice-unquote $(m.val))")

function Base.show(io::IO, m::MalVec)
    print(io, "[")
    join(io, m.val, " ")
    print(io, "]")
end
# function Base.show(io::IO, m::MalHash)
#     print(io, "{")
#     join(io, m.val, " ")
#     print(io, "}")
# end

Base.show(io::IO, m::MalMetadata) =
    print(io, "(with-meta $(m.val) $(m.meta))")

pr_str(m::MalType, print_readably=true) =
    print_readably ? "$m" : unescape_string("$m")
