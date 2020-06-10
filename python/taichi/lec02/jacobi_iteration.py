import taichi as ti
import random

ti.init()

n = 20

A = ti.var(dt=ti.f32, shape=(n, n))
x = ti.var(dt=ti.f32, shape=n)
new_x = ti.var(dt=ti.f32, shape=n)
b = ti.var(dt=ti.f32, shape=n)

@ti.kernel
def iterate():
    
    for i in range(n):
        r = b[i]
        for j in range(n):
            if i != j:
                r -= A[i, j] * x[j]
                
        new_x[i] = r / A[i, i]
        
    for i in range(n):
        x[i] = new_x[i]

@ti.kernel
def residual() -> ti.f32:
    res = 0.0
    
    for i in range(n):
        r = b[i] * 1.0
        for j in range(n):
            r -= A[i, j] * x[j]
        res += r * r
        
    return res


def init():
    for i in range(n):
        for j in range(n):
            A[i, j] = random.random() - 0.5

        A[i, i] += n * 0.1
        
        b[i] = random.random() * 100


init()
for i in range(100):
    iterate()
    print(f'iter {i}, residual={residual():0.10f}')
    

for i in range(n):
    lhs = 0.0
    for j in range(n):
        lhs += A[i, j] * x[j]
    assert abs(lhs - b[i]) < 1e-4
