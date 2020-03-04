include("tcp.jl")
using .JStruct

a=Struct(
        TypeContainer(
                      ["b","a","c"],
                      Dict(
                          "b"=>CharField(3),
                          "a"=>Int16ub,
                          "c"=>CharField(6)
                      )
       )
)
println(Parse(a,IOBuffer([0x3b,0x3c,0x3d,0x12,0x13,0x3b,0x3c,0x3d,0x3b,0x3c,0x3d])))

