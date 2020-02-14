# https://github.com/JuliaLang/julia/pull/31079
# Add new `unzip` function

macro _boundscheck_meta()
    esc(Expr(:boundscheck))
end

macro _boundscheck_meta2()
    :($(esc(Expr(:boundscheck))))
end

macro _boundscheck_meta3()
    Expr(:boundscheck)
end

macro _boundscheck_meta4()
    :($(esc(:boundscheck)))
end
