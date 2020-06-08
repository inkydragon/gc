import taichi as ti

ti.init(debug=True, arch=ti.cpu)

a = ti.var(ti.i32, shape=(10))
b = ti.var(ti.i32, shape=(10))

@ti.kernel
def shift():
    for i in range(10):
        a[i] = b[i + 1]  # Runtime error in debug mode

shift()
