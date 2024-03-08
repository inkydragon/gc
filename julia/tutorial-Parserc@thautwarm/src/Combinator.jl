import Base: (&), (|), (<<), (>>), (!), getindex

Stream{T} = AbstractArray{T, 1}

Parser{T} = Fn{Stream{Token}, Tuple{Maybe{T}, Stream{Token}}}

function parse(p :: Parser{T}, s :: Stream{Token}) :: Tuple{Maybe{T}, Stream{Token}} where T
    p(s)
end


literal_by_type(typ :: Symbol) :: Parser{Token} =
    Parser{Token}(
        (stream :: Stream{Token}) ->
        @match stream begin
            [hd, tl...] && if hd.typ === typ end => (Some(hd), tl)
            a => (nothing, a)
        end
    )

literal_by_val(val :: String) :: Parser{Token} =
        Parser{Token}(
        (stream :: Stream{Token}) ->
            @match stream begin
                [hd, tl...] && if hd.val == val end => (Some(hd), tl)
                a => (nothing, a)
            end
        )


literal(predicate) :: Parser{Token} =
    Parser{Token}(
        @λ begin
            ([hd, tl...] && if predicate(hd) end) -> (Some(hd), tl)
            a -> (nothing, a)
        end
    )

and(p1 :: Parser{A}, p2 :: Parser{B}) where {A, B} =
    Parser{Tuple{A, B}}(
        (stream :: Stream{Token}) ->
        @match p1(stream) begin
        (nothing, _) && b => b
        (some1, tl) =>
        @match p2(tl) begin
        (nothing, _) => (nothing, stream)
        (some2, tl) => (Some((some1.value, some2.value)), tl)
        end
        end
    )

@inline (&)(p1 :: Parser{A}, p2 :: Parser{B}) where {A, B} = and(p1, p2)

or(p1 :: Parser{A}, p2 :: Parser{A}) where A =
    Parser{A}(
        (stream :: Stream{Token}) ->
        @match p1(stream) begin
            (nothing, _) => p2(stream)
            a => a
        end
    )

@inline (|)(p1 :: Parser{A}, p2 :: Parser{B}) where {A, B} = or(p1, p2)

struct Inf <: Number end
∞ = Inf()

function seq(p :: Parser{A}, atleast :: Number, atmost :: Number) :: Parser{Vector{A}} where A
    Parser{Vector{A}}(
        atmost === ∞ ?
        function (stream :: Stream{Token})
            res :: Vector{A} = []
            remained = stream
            while true
                (elt, remained) = p(remained)
                if elt === nothing
                    break
                end
                push!(res, elt.value)
            end
            length(res) < atleast ?
                (nothing, stream) :
                (Some(res), remained)
        end :
        function (stream :: Stream{Token})
            res :: Vector{A} = []
            remained = stream
            while true
                (elt, remained) = p(remained)
                if elt === nothing || length(res) > atmost
                    break
                end
                push!(res, elt.value)
            end
            length(res) < atleast ?
                (nothing, stream) :
                (Some(res), remained)
        end
    )
end


"""
p[1]
p[2]
"""
getindex(p :: Parser{A}, atleast :: Int) where A = seq(p, atleast, ∞)
"""
p[1, 2]
p[1, 5]
"""
getindex(p :: Parser{A}, atleast :: Int, atmost :: T) where {A, T <: Number} = seq(p, atleast, atmost)

opt(p :: Parser{A}) where A =
    Parser{Maybe{A}}(
        (stream :: Stream{Token}) ->
        @match p(stream) begin
            (nothing, _) => (Some(nothing), stream)
            (some, tl) => (Some(some), tl)
        end
    )

# trans :: Parser a -> (a -> b) -> Parser b
trans(p :: Parser{A}, fn :: Fn{A, B}) where {A, B} =
    Parser{B}(
        (stream :: Stream{Token}) ->
        @match p(stream) begin
            (nothing, _) && a => a
            (some, tl) => (Some(fn(some.value)), tl)
        end
    )

⇒(p :: Parser{A}, fn :: Fn{A, B}) where {A, B} = trans(p, fn)

function not(p :: Parser{A}) :: Parser{Token} where A
    Parser{Token}(
        stream ->
        @match (stream, p(stream)) begin
            ([hd, tl...], (nothing, _)) => (Some(hd), tl)
            _ => (nothing, stream)
        end
    )
end

!(p) = not(p)


(>>)(a :: Parser{A}, b :: Parser{B}) where {A, B} = (a & b) ⇒ Fn{Tuple{A, B}, B}(((a, b), ) -> b)
(<<)(a :: Parser{A}, b :: Parser{B}) where {A, B} = (a & b) ⇒ Fn{Tuple{A, B}, A}(((a, b), ) -> a)

#
# mock_stream = [
#     Token(:parens, "(", 1, 1, 1, "..."),
#     Token(:identifier, "a", 1, 1, 1, "..."),
#     Token(:parens, ")", 1, 1, 1, "..."),
# ]
#
# parse(lisp, mock_stream) |> println

