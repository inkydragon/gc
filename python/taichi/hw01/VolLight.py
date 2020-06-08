import taichi as ti
import numpy as np
import math
import time

ti.init(arch=ti.opengl)

def vec(*xs):
    return ti.Vector(list(xs))


pixel = ti.var(ti.f32, (512, 512))
shadow = ti.var(ti.f32, (256, 256, 256))
#forward = ti.Vector(3, ti.f32, ())
iTime = ti.var(ti.f32, ())

@ti.func
def scene(p):
    c = ti.cos(iTime[None])
    s = ti.sin(iTime[None])
    t1 = ti.Matrix([
            [1.0, 0.0, 0.0],
            [0.0, c, -s],
            [0.0, s, c],
        ])
    c = ti.cos(iTime[None] * 1.2)
    s = ti.sin(iTime[None] * 1.2)
    t2 = ti.Matrix([
            [c, 0.0, s],
            [0.0, 1.0, 0.0],
            [-s, 0.0, c],
        ])
    return ti.abs(t1 @ t2 @ p).max() - 0.1 - s * 0.06

@ti.func
def phase(a, b):
    cos = a.dot(b)# / (a.norm() * b.norm())
    #return (0.1875 / math.pi) / (1 - cos ** 2)
    return (0.1875 / math.pi) * (1 + cos ** 2)

@ti.func
def extinAt(p):
    return 0.9

@ti.func
def absorAt(p):
    return 0.4

@ti.func
def shadowAt(p):
    p = (p + 2) * 0.25
    I = ti.cast(p * 256, ti.i32)
    shad = 1 - shadow[I]
    return shad

@ti.kernel
def render_shadow():
    light = vec(0.0, 0.8, 0.4).normalized()
    dstep = 0.006

    for I in ti.grouped(shadow):
        shadow[I] = 0
        #trans = 1.0
        p = I * (4 / 256) - 2
        for i in range(250):
            p = p - light * dstep
            sdf = scene(p)
            if sdf < 0.0:
                shadow[I] = 1

@ti.func
def lightAt(p, d):
    light = vec(0.0, 0.8, 0.4).normalized()
    dstep = 0.006

    trans = 1.0
    shad = shadowAt(p)
    for i in range(250):
        p = p + d * dstep
        trans *= ti.exp(-dstep * extinAt(p))

    return 20 * trans * shad

@ti.func
def radiance(p, d):
    light = vec(0.0, 0.8, 0.4).normalized()
    dstep = 0.006

    trans = 1.0
    total = 0.0
    for i in range(250):
        p = p + d * dstep
        sdf = scene(p)
        if sdf < 0.0:
            total = 1.0
            break
        insca = extinAt(p) - absorAt(p)
        total += trans * lightAt(p, d) * insca * phase(light, d) * dstep
    return total

@ti.kernel
def render():
    # Thanks to the issue #1109:
    #fwd = forward[None]
    #up = fwd.cross(vec(0.0, 1.0, 0.0)).normalized()
    #right = up.cross(fwd)
    #cam = ti.Matrix(cols=[fwd, right, up])
    #o = -1.0 * fwd
    o = vec(-1.0, 0.0, 0.0)
    for i, j in pixel:
        d = (vec(2.0, 2.0 / 512 * i - 1, 2.0 / 512 * j - 1)).normalized()
        p = o
        pixel[i, j] = radiance(p, d)


gui = ti.GUI('Volumetric Light')
for frame in range(10000):
    for e in gui.get_events():
        if e.key == ti.GUI.ESCAPE:
            exit()

    if frame % 4 == 0:
        render_shadow()

    render()
    gui.set_image(pixel.to_numpy())
    # gui.show()
    gui.show(f'{frame:03d}.png')
    iTime[None] = iTime[None] + 0.01
