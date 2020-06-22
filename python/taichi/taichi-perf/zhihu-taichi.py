import taichi as ti
import time
import math

ti.init(arch=ti.gpu)

@ti.kernel
def calc_pi() -> ti.f32:
    sum = 0.0
    for i in range(66_666_666):
        n = 2 * i + 1
        sum += pow(-1.0, i) / n
    return sum * 4


t0 = time.time()
print('Math.PI =', math.pi)
print('     PI =', calc_pi())
t1 = time.time()
print(f'Taichi: {t1 - t0:.3} sec')
