# Arith
using MLStyle
using Test
# 1. define Arith
@data Arith begin
    Num(v :: Int)
    Min(fst :: Arith, snd :: Arith)
    Add(fst :: Arith, snd :: Arith)
    Mul(fst :: Arith, snd :: Arith)
    Div(fst :: Arith, snd :: Arith)
end
@data Val begin
    
end
# 2. define interfaces
function eval_arith(arith :: Arith) 
    @match arith begin
        Num(v)        => v
        Add(fst, snd) => eval_arith(fst) + eval_arith(snd)
        Min(fst, snd) => eval_arith(fst) - eval_arith(snd)
        Mul(fst, snd) => eval_arith(fst) * eval_arith(snd)
        Div(fst, snd) => eval_arith(fst) / eval_arith(snd)
    end
end
Number = Num
eval_arith(
    Add(Number(1),
        Min(Number(2),
            Div(Number(20),
                    Mul(Number(2),
                        Number(5)))))) == 1
