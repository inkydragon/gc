import taichi as ti
import time

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)

"""
spores - by: mprice
https://www.shadertoy.com/view/4lsXWj
"""
GUI_TITLE = "Spores"
w, h = wh = (640, 360)
# w, h = wh = (360, 640)
pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])

MAX_ITER = 100
MAX_DIST = 20.0
EPSILON = 0.001
PI = 3.14159265

HIT_HOLE = 0
HIT_BARREL = 1
flag = ti.var(ti.i32, shape=2)
flag[HIT_HOLE] = False
flag[HIT_BARREL] = False

## Shader help func
@ti.func
def mix(x, y, a: ti.f32):
    """
    [The Book of Shaders: mix](https://thebookofshaders.com/glossary/?search=mix)
    """
    return x*(1-a) + y*a

@ti.func
def clamp(x, minVal, maxVal):
    """
    [The Book of Shaders: clamp](https://thebookofshaders.com/glossary/?search=clamp)
    """
    return min(max(x, minVal), maxVal)

@ti.func
def smoothstep(edge0, edge1, x):
    """
    [The Book of Shaders: smoothstep](https://thebookofshaders.com/glossary/?search=smoothstep)
    """
    t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)


@ti.func
def rotateX(p: ti.Vector, ang: ti.f32) -> ti.Vector:
    rmat: ti.Matrix = ti.Matrix([
        [1.0,  0.0,          0.0        ],
        [0.0,  ti.cos(ang), -ti.sin(ang)],
        [0.0,  ti.sin(ang),  ti.cos(ang)]
    ])
    return rmat @ p


@ti.func
def rotateY(p: ti.Vector, ang: ti.f32) -> ti.Vector:
    rmat: ti.Matrix = ti.Matrix([
        [ ti.cos(ang),  0.0,  ti.sin(ang)],
        [ 0.0,          1.0,  0.0        ],
        [-ti.sin(ang),  0.0,  ti.cos(ang)]
    ])
    return rmat @ p


@ti.func
def rotateZ(p: ti.Vector, ang: ti.f32) -> ti.Vector:
    rmat: ti.Matrix = ti.Matrix([
        [ti.cos(ang), -ti.sin(ang), 0.0],
        [ti.sin(ang),  ti.cos(ang), 0.0],
        [0.0,          0.0,         1.0]
    ])
    return rmat @ p


@ti.func
def sphere(pos: ti.Vector, r: ti.f32) -> ti.f32:
    return pos.norm() - r


@ti.func
def barrel(pos: ti.Vector) -> ti.f32:
    d: ti.f32 = sphere(pos, 0.5)
    pos[1] += 0.5
    holed: ti.f32 = -sphere(pos, 0.25)
    d = max(d, holed)
    if holed == d:
        flag[HIT_HOLE] = True
    else:
        flag[HIT_HOLE] = flag[HIT_HOLE]
    
    return d


@ti.func
def placedBarrel(
    pos: ti.Vector, 
    rx: ti.f32, 
    ry: ti.f32
) -> ti.f32:
    pos = rotateY(pos, ry)
    pos = rotateX(pos, rx)
    pos[1] += 2.0
    return barrel(pos)


@ti.func
def distfunc(iTime: ti.f32, pos: ti.Vector) -> ti.f32:
    pos += ti.Vector([iTime, iTime, iTime])
    c = ti.Vector([10.0, 10.0, 10.0])
    pos = (pos % c) - 0.5*c
    pos = rotateX(pos, iTime)

    flag[HIT_HOLE] = False
    flag[HIT_BARREL] = False

    # Any of you smart people have a domain transformation way to
    # do a rotational tiling effect instead of this? :)
    sphered: ti.f32 = sphere(pos, 2.0)
    d: ti.f32 = sphered
    ## 下面是给球上添加突起
    d = min(d, placedBarrel(pos, 0., 0.))
    # d = min(d, placedBarrel(pos, 0.8, 0.))
    # d = min(d, placedBarrel(pos, 1.6, 0.))
    # d = min(d, placedBarrel(pos, 2.4, 0.))
    # d = min(d, placedBarrel(pos, 3.2, 0.))
    # d = min(d, placedBarrel(pos, 4.0, 0.))
    # d = min(d, placedBarrel(pos, 4.8, 0.))
    # d = min(d, placedBarrel(pos, 5.6, 0.))

    # d = min(d, placedBarrel(pos, 0.8, PI / 2.0))
    # d = min(d, placedBarrel(pos, 1.6, PI / 2.0))
    # d = min(d, placedBarrel(pos, 2.4, PI / 2.0))
    # d = min(d, placedBarrel(pos, 4.0, PI / 2.0))
    # d = min(d, placedBarrel(pos, 4.8, PI / 2.0))
    # d = min(d, placedBarrel(pos, 5.6, PI / 2.0))
    # d = min(d, placedBarrel(pos, 1.2, PI / 4.0))
    # d = min(d, placedBarrel(pos, 2.0, PI / 4.0))

    # d = min(d, placedBarrel(pos, 1.2, 3.0 * PI / 4.0))
    # d = min(d, placedBarrel(pos, 2.0, 3.0 * PI / 4.0))
    # d = min(d, placedBarrel(pos, 1.2, 5.0 * PI / 4.0))
    # d = min(d, placedBarrel(pos, 2.0, 5.0 * PI / 4.0))
    # d = min(d, placedBarrel(pos, 1.2, 7.0 * PI / 4.0))
    # d = min(d, placedBarrel(pos, 2.0, 7.0 * PI / 4.0))

    flag[HIT_BARREL] = (d != sphered)

    return d


@ti.func
def mainImage(
    iMouse: ti.Vector, 
    iTime: ti.f32,
    i: ti.i32, 
    j: ti.i32
) -> ti.Vector:
    fragCoord = ti.Vector([i, j])
    fragColor = ti.Vector([0.0, 0.0, 0.0])

    m_x: ti.i32 = (iMouse[0] / iResolution[0]) - 0.5
    m_y: ti.i32 = (iMouse[1] / iResolution[1]) - 0.5

    ## vec3
    cameraOrigin = ti.Vector([
        5.0 * ti.sin(m_x * PI * 2.), 
        m_y * 15.0, 
        5.0 * ti.cos(m_x * PI * 2.)
    ])
    cameraTarget = ti.Vector([0.0, 0.0, 0.0])
    upDirection  = ti.Vector([0.0, 1.0, 0.0])
    cameraDir    = (cameraTarget - cameraOrigin).normalized()
    cameraRight  = upDirection.cross(cameraOrigin).normalized()
    cameraUp     = cameraDir.cross(cameraRight)
    # TODO: check (gl_FragCoord.xy == fragCoord)
    screenPos    = -1.0 + 2.0 * fragCoord / iResolution
    screenPos[0] *= iResolution[0] / iResolution[1]
    rayDir = (
        cameraRight * screenPos[0] \
        + cameraUp  * screenPos[1] \
        + cameraDir
    ).normalized()

    pos: ti.Vector = cameraOrigin
    totalDist = 0.0
    dist = EPSILON

    for _ in range(MAX_ITER):
        if (dist < EPSILON) or (totalDist > MAX_DIST):
            break
        
        dist = distfunc(iTime, pos)
        totalDist += dist
        pos += dist * rayDir
    # for i in range(MAX_ITER) END

    if (dist < EPSILON):
        eps = ti.Vector([0.0, EPSILON])
        eps_yxx = ti.Vector([EPSILON, 0.0, 0.0])
        eps_xyx = ti.Vector([0.0, EPSILON, 0.0])
        eps_xxy = ti.Vector([0.0, 0.0, EPSILON])
        normal = ti.Vector([
            distfunc(iTime, pos + eps_yxx) - distfunc(iTime, pos - eps_yxx),
            distfunc(iTime, pos + eps_xyx) - distfunc(iTime, pos - eps_xyx),
            distfunc(iTime, pos + eps_xxy) - distfunc(iTime, pos - eps_xxy)
        ]).normalized()
        lightdir = ti.Vector([1.0, -1.0, 0.0]).normalized()
        diffuse = max(0.2, lightdir.dot(normal))
        # tc = vec2(pos[0], pos.z)
        # texcol = texture(iChannel0, tc).rgb

        lightcol = ti.Vector([1.0, 1.0, 1.0])
        darkcol  = ti.Vector([0.4, 0.8, 0.9])
        sma = 0.4
        smb = 0.6

        if (flag[HIT_HOLE]): 
            lightcol = ti.Vector([1.0, 1.0, 0.8])
        elif flag[HIT_BARREL]:
            lightcol[0] = 0.95
        else:
            sma = 0.2
            smb = 0.3
        # if (HIT_HOLE) END

        facingRatio = smoothstep(sma, smb, abs(normal.dot(rayDir)))
        illumcol    = mix(lightcol, darkcol, 1.0 - facingRatio)
        fragColor   = illumcol
    
    else:  # dist >= EPSILON
        strp: ti.f32 = smoothstep(
            0.8, 0.9, 
            (screenPos[1] * 10. + iTime) % 1
        )
        fragColor = mix(
            ti.Vector([1.0, 1.0, 1.0]), 
            ti.Vector([0.4, 0.8, 0.9]), 
            strp
        )
    # if (dist <=> EPSILON) END
    
    return fragColor


@ti.kernel
def render(t: ti.f32):
    iMouse = gui.get_cursor_pos()
    for i, j in pixels:
        pixels[i, j] = mainImage(iMouse, t, i, j)

    return


gui = ti.GUI(GUI_TITLE, res=wh)
def main(output_img=False):
    print(time.strftime("%H:%M:%S, ", time.localtime()), end='')
    for ts in range(1000):
        if gui.get_event(ti.GUI.ESCAPE):
            exit()

        render(ts * 0.03)
        gui.set_image(pixels.to_numpy())
        if output_img:
            gui.show(f'frame/{ts:04d}.png')
        else:
            gui.show()
        if ts == 0:
            print(time.strftime("%H:%M:%S", time.localtime()))


if __name__ == '__main__':
    main(output_img=True)
    # main()
