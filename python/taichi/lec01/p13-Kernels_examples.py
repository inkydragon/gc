import taichi as ti

ti.init(arch=ti.cpu)

@ti.kernel
def hello(i: ti.i32):
    a = 40
    print('Hello world!', a + i)

hello(2)
# "Hello world! 42"


@ti.kernel
def calc() -> ti.i32:
    s = 0
    for i in range(10):
        s += i
    return s

print(calc())
# "45"
