import taichi as ti
import numpy as np

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)

# Equi-Angular Sampling
# https://www.shadertoy.com/view/Xdf3zB
GUI_TITLE = "Equi-Angular Sampling"
h, w = iResolution = (640, 320)
pixels = ti.Vector(3, dt=ti.f32, shape=iResolution)

# 常量定义
PI = 3.1415926535
SIGMA = 0.3
STEP_COUNT = 16
DIST_MAX = 10.0
LIGHT_POWER = 12.0
SURFACE_ALBEDO = 0.7
EPS = 0.01

###
@ti.func
def vec2(x, y):
    return ti.Vector([x, y])

def vec3(x, y, z):
    return ti.Vector([x, y, z])

def vec3(x, y, z, a):
    return ti.Vector([x, y, z, a])

def normalize(expr):
    return (expr).normalized()

def cross(x, y):
    return x.cross(y)

def dot(x, y):
    return x.dot(y)

def length(v):
    return v.norm()

###



@ti.func
def hash(n: ti.f32):
    return ti.sin(n) * 43758.5453123 % 1 # 仅保留小数



@ti.func
def mainImage(t: ti.f32, i: ti.i32, j: ti.i32):
    """
    ## input
        t       # iTime
        [i, j]  # fragCoord.xy

    ## output
        fragColor   # fragColor
    """
    # coords-trans
    coords = -1.0 + 2.0 * ti.Vector([i / h, j / w])
    coords[0] *= (h / w)
    
    # camera
    ro = ti.Vector([ti.sin(t*0.16), 0.0, ti.cos(t*0.1)])
    ta = ro + ti.Vector([ti.sin(t*0.15), ti.sin(t*0.18), ti.cos(t*0.24)])

    # camera tx
    cw = (ta - ro).normalized()
    cp = ti.Vector([0.0, 1.0, 0.0])
    cu = cp.cross(cw).normalized()
    rd = (coords[0]*cu + coords[1]*cp + cw*2.0 ).normalized()

    # volumetric rendering
    v = ti.Vector([0.0, 0.0, 0.0])
    for i1 in range(50):
        s1 = (i1+1)*0.1
        p = ro + rd * s1

        for i2 in range(8):
            s2 = 0.1 + i2 * 0.12
            # the magic formula
            p = -0.5 + abs(p) / (p + ti.sin(t * 0.1) * 0.1).dot(p)
            a = p.norm() * 0.12 # absolute sum of average change
            # coloring based on distance
            v += ti.Vector([a * s2, a * s2**2, a * s2**3])

    fragColor = v * 0.01
    return fragColor


@ti.kernel
def render(t: ti.f32):
    for i, j in pixels:
        pixels[i,j] = mainImage(t, i, j)
    
    return


def main(img=False):
    """
    img = True # 输出 png
    """
    gui = ti.GUI(GUI_TITLE, res=iResolution)
    for ts in range(1000000):
        if gui.get_event(ti.GUI.ESCAPE):
            exit()
        
        render(ts * 0.03)
        gui.set_image(pixels.to_numpy())
        if img:
            gui.show()
        else:
            gui.show(f'frame/{ts:04d}.png')

if __name__ == '__main__':
    # main(img=True)
    main()
