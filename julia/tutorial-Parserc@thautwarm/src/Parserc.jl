module Parserc
using MLStyle

export lex, literal, literal_by_type, literal_by_val, or, and, trans, not, Fn, parse, Token, Parser
export ⇒, (&), (|), (<<), (>>), (!), ∞

Maybe{T} = Union{Some{T}, Nothing}

include("Token.jl")
include("TypedFunc.jl")
include("Combinator.jl")
include("Lexer.jl")

end # module
