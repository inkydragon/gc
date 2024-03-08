struct Fn{Arg, Ret, A}
    f :: A
end

@inline Fn{Arg, Ret}(f :: A) where {Arg, Ret, A}= Fn{Arg, Ret, A}(f)

@generated function (f :: Fn{Arg, Ret, A})(a :: Arg) :: Ret where {Arg, Ret, A}
    quote
        $(Expr(:meta, :inline))
        f.f(a)
    end
end
