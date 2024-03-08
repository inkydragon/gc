#=
red.txt
"
I am the bone of my sword.
...
"
[
    Token(:Identifier, "I", 1, 1, 1, "red.txt"),
    Token(:Space, " ", 2, 1, 2, "red.txt"),
    Token("am"),
    " ",
    "the"
    " ",
    "bone",
    " ",
    "of",
    " ",
    "my",
    " ",
    "sword",
    ".",
    "\n",
    "..."
]
=#

struct Token
    typ :: Symbol
    val :: String
    offset :: Int
    lineno :: Int
    colno  :: Int
    filename :: Union{Nothing, String}
end

#=
    "1 + 1"
    -> stream = [Token("1"), Token("+"), Token("1")]
        for
            Token("1") -> Number(1)
            Token("+") -> AddOp()
    ->
        Add(op = AddOp(),
            left = Number(1),
            right = Number(1))

    add11 :: Parser{Add}
    stream :: Stream{Token}
    Maybe{T} = Union{Some{T}, Nothing}


    parse(add11 :: Parser{Add}, stream :: Stream{Token}) :: Tuple{Maybe{Add}, Stream{Token}} =
        Some(
            Add(op = BinaryOperator(AddOp()),
               left = Number(1),
               right = Number(1))),
        []

    Parser{T} = Stream{Token} -> Tuple{Maybe{T}, Stream{Token}} where T
    parse :: (Parser{T}, Stream{Token}) -> Tuple{Maybe{T}, Stream{Token}} where T
=#