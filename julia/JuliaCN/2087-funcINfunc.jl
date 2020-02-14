# function err(k)
#     a=[1,2,3,4,5,6]
#     f() = nothing # 在与调用同级/能访问到的作用域上，提前声明一下
#     if k==1
#         f()=(a[1]=0)
#     elseif k==2
#         f()=(a[2]=0)
#     else 
#         f()=(a[3]=0)
#     end
#     f()
#     println("[k=$k] a=",string(a))
# end
# 
# l=2
# b=[1,2,3,4,5,6]
# if l==1
#     g()=(b[1]=0)
# elseif l==2
#     g()=(b[2]=0)
# else 
#     g()=(b[3]=0)
# end
# g()
# println("b=", string(b))
# 
# err(1)
# err(3)
# err(6)
# 
# function test(x,y)
#    # f() = nothing 
#    if x < y
#       f() = "less than"
#       println(-1)
#    elseif x == y
#       f() = "equal to"
#       println(0)
#    elseif x > y
#       f() = "greater than"
#       println(1)
#    else
#       f() = "绝了"
#       println("绝了")
#    end
#    println("x is ", f(), " y.")
# end

function tst(x::Int)
   # f() = nothing 
   if x == 1
      f() = 1
      println(1)
   elseif x == 0
      f() = 0
      println(0)
   elseif x == -1
      f() = -1
      println(1)
   else
      f() = 233
      println(233)
   end
   println("x=", x, "; f=", f())
end
# julia> tst(1)
# 1
# x=1; f=233
# 
# julia> tst(0)
# 0
# ERROR: UndefVarError: f not defined
# Stacktrace:
#  [1] tst(::Int64) at C:\Users\woclass\Desktop\proj\Julia\JuliaCN\2087-funcINfunc.jl:64
#  [2] top-level scope at none:0
# 
# julia> tst(-1)
# 1
# ERROR: UndefVarError: f not defined
# Stacktrace:
#  [1] tst(::Int64) at C:\Users\woclass\Desktop\proj\Julia\JuliaCN\2087-funcINfunc.jl:64
#  [2] top-level scope at none:0



# code_llvm(tst, Int)
