import taichi as ti
import numpy as np
import time

ti.init(arch=ti.gpu)

# res = 1280, 720
res = 320, 180

pixels = ti.Vector(3, dt=ti.f32, shape=res)

sun_dir = ti.Vector([-1.0, 0.0, -1.0])


@ti.func
def clamp(x):
    return ti.max(0, ti.min(1.0, x))


@ti.func
def mod289(x):
    return x - ti.floor(x * (1.0 / 289.0)) * 289.0


@ti.func
def perm(x):
    return mod289(((x * 34.0) + 1.0) * x)


@ti.func
def fract(x):
    return x - ti.floor(x)


# Reference https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
@ti.func
def noise(p):
    a = ti.floor(p)
    d = p - a
    d = d * d * (3.0 - 2.0 * d)
    b = ti.Vector([a[0], a[0] + 1.0, a[1], a[1] + 1.0])
    k1 = perm(ti.Vector([b[0], b[1], b[0], b[1]]))
    k2 = perm(
        ti.Vector([k1[0] + b[2], k1[1] + b[2], k1[0] + b[3], k1[1] + b[3]]))
    c = k2 + ti.Vector([a[2], a[2], a[2], a[2]])
    k3 = perm(c)
    k4 = perm(c + 1.0)
    o1 = fract(k3 * (1.0 / 41.0))
    o2 = fract(k4 * (1.0 / 41.0))
    o3 = o2 * d[2] + o1 * (1.0 - d[2])
    o4 = ti.Vector([o3[1], o3[3]]) * d[0] + ti.Vector([o3[0], o3[2]
                                                       ]) * (1.0 - d[0])
    return o4[1] * d[1] + o4[0] * (1.0 - d[1])


@ti.func
def map5(p, timestep):
    q = p - ti.Vector([0.0, 0.1, 1.0]) * timestep
    f = 0.50000 * noise(q)
    q = q * 2.02
    f += 0.25000 * noise(q)
    q = q * 2.03
    f += 0.12500 * noise(q)
    q = q * 2.01
    f += 0.06250 * noise(q)
    q = q * 2.02
    f += 0.03125 * noise(q)
    return clamp(1.5 - p[1] - 2.0 + 1.75 * f)


@ti.func
def map4(p, timestep):
    q = p - ti.Vector([0.0, 0.1, 1.0]) * timestep
    f = 0.50000 * noise(q)
    q = q * 2.02
    f += 0.25000 * noise(q)
    q = q * 2.03
    f += 0.12500 * noise(q)
    q = q * 2.01
    f += 0.06250 * noise(q)
    return clamp(1.5 - p[1] - 2.0 + 1.75 * f)


@ti.func
def map3(p, timestep):
    q = p - ti.Vector([0.0, 0.1, 1.0]) * timestep
    f = 0.50000 * noise(q)
    q = q * 2.02
    f += 0.25000 * noise(q)
    q = q * 2.03
    f += 0.12500 * noise(q)
    return clamp(1.5 - p[1] - 2.0 + 1.75 * f)


@ti.func
def map2(p, timestep):
    q = p - ti.Vector([0.0, 0.1, 1.0]) * timestep
    f = 0.50000 * noise(q)
    q = q * 2.02
    f += 0.25000 * noise(q)
    return clamp(1.5 - p[1] - 2.0 + 1.75 * f)


@ti.func
def lerp(x, y, a):
    return x * (1 - a) + y * a


@ti.func
def ray_march(ro, rd, bgcol, timestep):
    sum = ti.Vector([0.0, 0.0, 0.0, 0.0])
    t = 0.0
    # map5
    for i in range(30):
        pos = ro + t * rd
        if pos[1] < -3.0 or pos[1] > 2.0 or sum[3] > 0.99:
            break
        den = map5(pos, timestep)
        if den > 0.01:
            diff = clamp((den - map5(pos + 0.3 * sun_dir, timestep)) / 0.6)
            lin = ti.Vector([0.65, 0.7, 0.75]) * 1.4 + ti.Vector(
                [1.0, 0.6, 0.3]) * diff
            mix = ti.Vector([1.0, 0.95, 0.8]) * (1 - den) + ti.Vector(
                [0.25, 0.3, 0.35]) * den
            col = ti.Vector(
                [mix[0] * lin[0], mix[1] * lin[1], mix[2] * lin[2], den])
            intepolated = 1.0 - ti.exp(-0.003 * t * t)
            col[0] = lerp(col[0], bgcol[0], intepolated)
            col[1] = lerp(col[1], bgcol[1], intepolated)
            col[2] = lerp(col[2], bgcol[2], intepolated)
            col[3] *= 0.4
            col[0] *= col[3]
            col[1] *= col[3]
            col[2] *= col[3]
            sum += col * (1.0 - sum[3])
        t += max(0.05, 0.02 * t)
    # map4
    for i in range(30):
        pos = ro + t * rd
        if pos[1] < -3.0 or pos[1] > 2.0 or sum[3] > 0.99:
            break
        den = map4(pos, timestep)
        if den > 0.01:
            diff = clamp((den - map4(pos + 0.3 * sun_dir, timestep)) / 0.6)
            lin = ti.Vector([0.65, 0.7, 0.75]) * 1.4 + ti.Vector(
                [1.0, 0.6, 0.3]) * diff
            mix = ti.Vector([1.0, 0.95, 0.8]) * (1 - den) + ti.Vector(
                [0.25, 0.3, 0.35]) * den
            col = ti.Vector(
                [mix[0] * lin[0], mix[1] * lin[1], mix[2] * lin[2], den])
            intepolated = 1.0 - ti.exp(-0.003 * t * t)
            col[0] = lerp(col[0], bgcol[0], intepolated)
            col[1] = lerp(col[1], bgcol[1], intepolated)
            col[2] = lerp(col[2], bgcol[2], intepolated)
            col[3] *= 0.4
            col[0] *= col[3]
            col[1] *= col[3]
            col[2] *= col[3]
            sum += col * (1.0 - sum[3])
        t += max(0.05, 0.02 * t)
    #map3
    for i in range(30):
        pos = ro + t * rd
        if pos[1] < -3.0 or pos[1] > 2.0 or sum[3] > 0.99:
            break
        den = map3(pos, timestep)
        if den > 0.01:
            diff = clamp((den - map3(pos + 0.3 * sun_dir, timestep)) / 0.6)
            lin = ti.Vector([0.65, 0.7, 0.75]) * 1.4 + ti.Vector(
                [1.0, 0.6, 0.3]) * diff
            mix = ti.Vector([1.0, 0.95, 0.8]) * (1 - den) + ti.Vector(
                [0.25, 0.3, 0.35]) * den
            col = ti.Vector(
                [mix[0] * lin[0], mix[1] * lin[1], mix[2] * lin[2], den])
            intepolated = 1.0 - ti.exp(-0.003 * t * t)
            col[0] = lerp(col[0], bgcol[0], intepolated)
            col[1] = lerp(col[1], bgcol[1], intepolated)
            col[2] = lerp(col[2], bgcol[2], intepolated)
            col[3] *= 0.4
            col[0] *= col[3]
            col[1] *= col[3]
            col[2] *= col[3]
            sum += col * (1.0 - sum[3])
        t += max(0.05, 0.02 * t)
    # map2
    for i in range(30):
        pos = ro + t * rd
        if pos[1] < -3.0 or pos[1] > 2.0 or sum[3] > 0.99:
            break
        den = map2(pos, timestep)
        if den > 0.01:
            diff = clamp((den - map2(pos + 0.3 * sun_dir, timestep)) / 0.6)
            lin = ti.Vector([0.65, 0.7, 0.75]) * 1.4 + ti.Vector(
                [1.0, 0.6, 0.3]) * diff
            mix = ti.Vector([1.0, 0.95, 0.8]) * (1 - den) + ti.Vector(
                [0.25, 0.3, 0.35]) * den
            col = ti.Vector(
                [mix[0] * lin[0], mix[1] * lin[1], mix[2] * lin[2], den])
            intepolated = 1.0 - ti.exp(-0.003 * t * t)
            col[0] = lerp(col[0], bgcol[0], intepolated)
            col[1] = lerp(col[1], bgcol[1], intepolated)
            col[2] = lerp(col[2], bgcol[2], intepolated)
            col[3] *= 0.4
            col[0] *= col[3]
            col[1] *= col[3]
            col[2] *= col[3]
            sum += col * (1.0 - sum[3])
        t += max(0.05, 0.02 * t)
    return clamp(sum)


@ti.func
def set_camera(ro, up, cr):
    cw = (up - ro).normalized()
    cp = ti.Vector([ti.sin(cr), ti.cos(cr), 0.0])
    cu = cw.cross(cp).normalized()
    cv = cu.cross(cw).normalized()
    return ti.Matrix(cols=[cu, cv, cw])


## Reference https://www.shadertoy.com/view/XslGRr
@ti.kernel
def render(timestep: ti.f32, m: ti.ext_arr()):
    for x, y in pixels:
        p = (2.0 * x - res[0]) / res[1], (2.0 * y - res[1]) / res[1]
        rayo = 4.0 * ti.Vector(
            [ti.sin(3.0 * m[0]), 0.4 * m[1],
             ti.cos(3.0 * m[0])])
        up = ti.Vector([0.0, -1.0, 0.0])
        rotation = 0.0
        camera = set_camera(rayo, up, rotation)
        rayd = camera @ ti.Vector([p[0], p[1], 1.5]).normalized()
        # sky
        sun = clamp(sun_dir.normalized().dot(rayd))
        col = ti.Vector([
            0.6, 0.71, 0.75
        ]) - rayd[1] * 0.2 * ti.Vector([1.0, 0.5, 1.0]) + 0.15 * 0.5
        col += 0.2 * ti.Vector([1.0, .6, 0.1]) * ti.pow(sun, 8.0)
        #cloud
        ret = ray_march(rayo, rayd, col, timestep)
        col = col * (1.0 - ret[3]) + ti.Vector([ret[0], ret[1], ret[2]])
        # glare
        col += 0.2 * ti.Vector([1.0, 0.4, 0.2]) * pow(sun, 3.0)
        # output to pixels
        pixels[x, y] = col


def main():
    gui = ti.GUI('Volumetric_clouds', res)
    paused = False
    timestep = 0
    m = np.array([0.5, 0.5], dtype=np.float32)
    while True:
        while gui.get_event(ti.GUI.PRESS):
            e = gui.event
            if e.key == ti.GUI.ESCAPE:
                exit(0)
            elif e.key == 'p':
                paused = not paused

        if not paused:
            if gui.is_pressed(ti.GUI.LMB):
                mouse_data = gui.get_cursor_pos()
                m = np.array([mouse_data[0], mouse_data[1]], dtype=np.float32)
            render(timestep * 0.1, m)

        gui.set_image(pixels.to_numpy())
        gui.show()
        timestep += 1

def main2():
    gui = ti.GUI('Volumetric_clouds', res)
    paused = False
    timestep = 0
    m = np.array([0.5, 0.5], dtype=np.float32)
    while True:
        while gui.get_event(ti.GUI.PRESS):
            e = gui.event
            if e.key == ti.GUI.ESCAPE:
                exit(0)
            elif e.key == 'p':
                paused = not paused

        if not paused:
            if gui.is_pressed(ti.GUI.LMB):
                mouse_data = gui.get_cursor_pos()
                m = np.array([mouse_data[0], mouse_data[1]], dtype=np.float32)
            render(timestep * 0.1, m)

        gui.set_image(pixels.to_numpy())
        gui.show(f'frame/{timestep:03d}.png')
        timestep += 1

if __name__ == '__main__':
    # main()
    main2()
    