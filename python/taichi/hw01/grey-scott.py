import taichi as ti
import numpy as np
import math
import time

# ti.init(arch=ti.cpu)
ti.init(arch=ti.gpu)
screen_res = (512, 512)
# grey-scott paramters
d_a = 1
d_b = 0.25
mu_a = 0.0367
mu_b = 0.0633
# feed and kill volume
v_a = ti.var(ti.f32, shape=screen_res)
v_b = ti.var(ti.f32, shape=screen_res)
v_da = ti.var(ti.f32, shape=screen_res)
v_db = ti.var(ti.f32, shape=screen_res)

@ti.func
def saturate(x):
    return ti.max(0, ti.min(1.0, x))

@ti.func
def laplacian(i,j):
    v_da[i,j] = v_a[i-1,j-1] * 0.05 + v_a[i-1,j]*0.2 + v_a[i-1,j+1]*0.05 +\
                v_a[i  ,j-1] * 0.2  + v_a[i  ,j]*-1  + v_a[i  ,j+1]*0.2 +\
                v_a[i+1,j-1] * 0.05 + v_a[i+1,j]*0.2 + v_a[i+1,j+1]*0.05

    v_db[i,j] = v_b[i-1,j-1] * 0.05 + v_b[i-1,j]*0.2 + v_b[i-1,j+1]*0.05  +\
                v_b[i  ,j-1] * 0.2  + v_b[i  ,j]*-1  + v_b[i  ,j+1]*0.2 +\
                v_b[i+1,j-1] * 0.05 + v_b[i+1,j]*0.2 + v_b[i+1,j+1]*0.05
    return 

@ti.func
def react_diffuse(i,j):
    v_a[i,j] += v_da[i,j]*d_a - v_a[i,j]*v_b[i,j]*v_b[i,j] + mu_a*(1-v_a[i,j])
    v_b[i,j] += v_db[i,j]*d_b + v_a[i,j]*v_b[i,j]*v_b[i,j] - (mu_a+mu_b)*v_b[i,j]
    v_a[i,j] = saturate(v_a[i,j])
    v_b[i,j] = saturate(v_b[i,j])

@ti.kernel
def init():
    for i, j in v_a:
        v_a[i,j] = ti.random()
        v_b[i,j] = ti.random()

@ti.kernel
def update():
    for i, j in ti.ndrange((1, screen_res[0] - 1), (1, screen_res[1] - 1)):
        laplacian(i,j)
        react_diffuse(i,j)

init()
gui = ti.GUI('Grey Scot Diffusion Reaction', screen_res)

# while not gui.get_event(ti.GUI.ESCAPE):
#     # 5 substep
#     for i in range(0,5):
#         update()
#     image = v_a.to_numpy()*255
#     gui.set_image(image.astype(np.uint8))
#     gui.show()

for frame in range(10000):
    if gui.get_event(ti.GUI.ESCAPE):
        exit()

    # 5 substep
    for i in range(0,5):
        update()
    image = v_a.to_numpy()*255
    gui.set_image(image.astype(np.uint8))
    gui.show(f'gs/{frame:04d}.png')
