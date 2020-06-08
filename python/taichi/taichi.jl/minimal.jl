using Taichi


"""
@ti.kernel
def p():
    print(42)

"""
@kernel function p()
    println(42)
end

p()
