# https://github.com/JuliaLang/julia/blob/master/base/show.jl#L741-L763
## Abstract Syntax Tree (AST) printing ##

# Summary:
#   print(io, ex) defers to show_unquoted(io, ex)
#   show(io, ex) defers to show_unquoted(io, QuoteNode(ex))
#   show_unquoted(io, ex) does the heavy lifting
#
# AST printing should follow two rules:
#   1. Meta.parse(string(ex)) == ex
#   2. eval(Meta.parse(repr(ex))) == ex

# -----
# fix bug in nested quote and nested $ with splatting
# https://github.com/JuliaLang/julia/commit/9ef17207d5f99c7a0019cbbe0e58f77e7c4c1d21

# ================================================================

EXPR = Expr(:$, :a)

## 00
repr(EXPR)
# => ":(\$(Expr(:\$, :a)))"

# repr(x; context=nothing) = sprint(show, x; context=context)
# https://github.com/JuliaLang/julia/blob/master/base/strings/io.jl#L221


## 01
sprint(show, EXPR)
# => ":(\$(Expr(:\$, :a)))"

# function sprint(f::Function, args...; context=nothing, sizehint::Integer=0)
#     s = IOBuffer(sizehint=sizehint)
#     if context !== nothing
#         f(IOContext(s, context), args...)
#     else
#         f(s, args...)
#     end
#     String(resize!(s.data, s.size))
# end
#
# https://github.com/JuliaLang/julia/blob/master/base/strings/io.jl#L102-L110


## 02
s = IOBuffer(sizehint=0)
show(s, EXPR)
s.ptr=1
read(s, String)
# => ":(\$(Expr(:\$, :a)))"

# show(io::IO, ex::ExprNode)    = show_unquoted_quote_expr(io, ex, 0, -1)
# https://github.com/JuliaLang/julia/blob/master/base/show.jl#L772


## 03
s = IOBuffer(sizehint=0)
Base.show_unquoted_quote_expr(s, EXPR, 0, -1)
s.ptr=1
read(s, String)
# => ":(\$(Expr(:\$, :a)))"

# function show_unquoted_quote_expr(io::IO, @nospecialize(value), indent::Int, prec::Int)
#     if isa(value, Symbol) && !(value in quoted_syms)
#         s = string(value)
#         if isidentifier(s) || isoperator(value)
#             print(io, ":")
#             print(io, value)
#         else
#             print(io, "Symbol(", repr(s), ")")
#         end
#     else
#         if isa(value,Expr) && value.head === :block
#             show_block(io, "quote", value, indent)
#             print(io, "end")
#         else
#             print(io, ":(")
#             show_unquoted(io, value, indent+2, -1)  # +2 for `:(`
#             print(io, ")")
#         end
#     end
# end
# 
# https://github.com/JuliaLang/julia/blob/master/base/show.jl#L1050-L1069


## 04
io = IOBuffer(sizehint=0)
print(io, ":(")
Base.show_unquoted(io, EXPR, 0+2, -1)  # +2 for `:(`
print(io, ")")
io.ptr=1
read(io, String)
# => ":(\$(Expr(:\$, :a)))"

# https://github.com/JuliaLang/julia/blob/master/base/show.jl#L1122
# function show_unquoted(io::IO, ex::Expr, indent::Int, prec::Int)
# 
# # .....
#
# https://github.com/JuliaLang/julia/blob/master/base/show.jl#L1422-L1428
# elseif (head === :&#= || head === :$=#) && nargs == 1
#     print(io, head)
#     a1 = args[1]
#     parens = (isa(a1,Expr) && a1.head !== :tuple) || (isa(a1,Symbol) && isoperator(a1))
#     parens && print(io, "(")
#     show_unquoted(io, a1)
#     parens && print(io, ")")
# 
# # .....

# Note
# > `elseif (head === :&#= || head === :$=#) && nargs == 1`
# fix bug in nested quote and nested $ with splatting
# https://github.com/JuliaLang/julia/commit/9ef17207d5f99c7a0019cbbe0e58f77e7c4c1d21

io = IOBuffer(sizehint=0)

ex = EXPR
head, args, nargs = ex.head, ex.args, length(ex.args)
print(io, head)
a1 = args[1]
parens = true
parens && print(io, "(")
Base.show_unquoted(io, a1)
parens && print(io, ")")

io.ptr=1
read(io, String)
# => "\$(a)"


# https://github.com/JuliaLang/julia/blob/master/base/show.jl#L1479-L1487
# if unhandled
#     print(io, "\$(Expr(")
#     show(io, ex.head)
#     for arg in args
#         print(io, ", ")
#         show(io, arg)
#     end
#     print(io, "))")
# end

io = IOBuffer(sizehint=0)
ex = EXPR

print(io, "\$(Expr(")
show(io, ex.head)
print(io, ", ")
show(io, args[1])
print(io, "))")

io.ptr=1
read(io, String)
# => "\$(Expr(:\$, :a))"


## 05

string(:$)
# "\$"
