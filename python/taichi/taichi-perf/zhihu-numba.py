import numba
import time
import math


@numba.jit(nopython=True)
def calc_pi():
    sum = 0.0
    for i in range(66_666_666):
        n = 2 * i + 1
        sum += pow(-1.0, i) / n
    return sum * 4


t0 = time.time()
print('Math.PI =', math.pi)
print('     PI =', calc_pi())
t1 = time.time()
print(f'Numba: {t1 - t0:.3} sec')

