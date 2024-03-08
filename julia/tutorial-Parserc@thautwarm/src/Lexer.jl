"""
"123 23 4" -> [Token("123"), Token(" "), ...]

source = "a = 1"
offset = 1

table = [
    :identifier => (source :: String, offset :: Int) -> Union{String, Nothing}
    :keyword => (...)
    :space => (...)
]

reserved = Dict(
    "let" => :keyword
)

lineno = 1
colno = 1
offset = 1
while offset <= length(source)
    for (typ, case) in table
        pat = case(source, offset)
        if pat === nothing
            continue
        end
        typ = get(reserved, pat) do
            typ
        end
        n = length(pat)
        put!(c, Token(typ, pat, offset, lineno, colno, filename)) # yield Token(...)
        increment lineno, colno via pat
        offset = offset + n
        break
    end
end
"""

LexerTable = Vector{Pair{Symbol, Function}}
Reserved = Dict{String, Symbol}

const NEWLINE= '\n'
function lex(text :: String, lexer_table :: LexerTable, reserved :: Reserved, fname :: String)
    Channel(c -> lex(c, text, lexer_table, reserved, fname))
end

function lex(c, text :: String, lexer_table :: LexerTable, reserved :: Reserved, fname :: String)
    text_length = length(text)
    colno  :: Int = 1
    lineno :: Int = 1
    pos    :: Int = 1

    while text_length >= pos
        is_unknown = true
        for (typ, case) in lexer_table
            pat :: Union{String, Nothing} = case(text, pos)
            if pat === nothing
                continue
            end

            let typ = get(reserved, pat) do
                    typ
                end
                put!(c, Token(typ, pat, pos, lineno, colno, fname))
            end

            pat_chars = collect(pat)
            n = length(pat_chars)
            line_inc = count(pat_chars .== NEWLINE)

            if line_inc !== 0
                latest_newline_idx = findlast(==(NEWLINE), pat_chars)
                colno = n - latest_newline_idx + 1
                lineno = lineno + line_inc
            else
                colno = colno + n
            end
            pos = pos + n
            is_unknown = false
            break
        end

        if !is_unknown
            continue
        end

        println("No handler for character `$(repr(text[pos]))`.")
        char = text[pos]
        put!(c, Token(:unknown, String([char]), pos, lineno, colno, fname))
        if char == '\n'
            lineno = 1 + lineno
            colno = 1 + colno
        end
        pos = pos + 1
    end
end