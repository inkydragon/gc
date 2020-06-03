import taichi as ti
import numpy as np
import math as m

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)

# Equi-Angular Sampling
# Implementation of equi-angular sampling for raymarching through homogenous media
# https://www.shadertoy.com/view/Xdf3zB
GUI_TITLE = "Equi-Angular Sampling"
w, h = wh = (512, 256)
pixels = ti.Vector(3, dt=ti.f32, shape=wh)

## 常量定义

from math import pi as PI
# PI              = 3.1415926535
SIGMA           = 0.3
STEP_COUNT      = 16
DIST_MAX        = 10.0
LIGHT_POWER     = 12.0
SURFACE_ALBEDO  = 0.7
EPS             = 0.01

## 辅助函数
@ti.func
def vec3(x):
    return ti.Vector([x, x, x])

@ti.func
def normalize(expr):
    return (expr).normalized()

@ti.func
def dot(x, y):
    return x.dot(y)

@ti.func
def length(v):
    return v.norm()

@ti.func
def mix(x, y, a: ti.f32):
    return x*(1-a) + y*a

##


## shader code ============================================
@ti.func
def fract(x: ti.f32):
    return x - ti.floor(x)

@ti.func
def hash(n: ti.f32):
    return fract(ti.sin(n) * 43758.5453123)

@ti.func
def sampleCamera(
    fragCoord: ti.Vector,   # vec2
    u: ti.Vector,           # vec2
    rayOrigin: ti.Vector    # vec3
):
    ## vec2
    filmUv = (fragCoord + u) / ti.Vector([w, h])
    ## f32
    tx = (2.0*filmUv[0] - 1.0) * (w/h)
    ty = 1.0 - 2.0*filmUv[1]
    tz = 0.0
    return normalize(ti.Vector([tx, ty, tz]) - rayOrigin)
# @ti.func sampleCamera


@ti.func
def intersectSphere(
    rayOrigin: ti.Vector,       # vec3
    rayDir: ti.Vector,          # vec3
    sphereCentre: ti.Vector,    # vec3
    sphereRadius: ti.f32,
    rayT: ti.f32 # [inout]
):
    # ray: x = o + dt, sphere: (x - c).(x - c) == r^2
    # let p = o - c, solve: (dt + p).(dt + p) == r^2
    # 
    # => (d.d)t^2 + 2(p.d)t + (p.p - r^2) == 0
    geomNormal = vec3(0.0)

    ## vec3
    p = rayOrigin - sphereCentre
    d = rayDir

    ## f32
    a = dot(d, d)
    b = 2.0 * dot(p, d)
    c = dot(p, p) - sphereRadius * sphereRadius
    q = b*b - 4.0*a*c

    if q > 0.0:
        ## f32
        denom = 0.5 / a
        z1 = -b * denom
        z2 = abs(ti.sqrt(q) * denom)
        t1 = z1 - z2
        t2 = z1 + z2

        intersected = False
        if (0.0 < t1) and (t1 < rayT):
            intersected = True
            rayT = t1
        elif (0.0 < t2) and (t2 < rayT):
            intersected = True
            rayT = t2

        if intersected:
            geomNormal = normalize(p + d*rayT)
    # if (q > 0.0) END
    return (rayT, geomNormal)
# @ti.func intersectSphere


@ti.func
def intersectScene(
    rayOrigin: ti.Vector,   # vec3
    rayDir: ti.Vector,      # vec3
    rayT: ti.f32 # [inout]
):
    rayT, geomNormal = intersectSphere(rayOrigin, rayDir, ti.Vector([-0.5,  0.5, 0.3]), 0.25, rayT)
    rayT, geomNormal = intersectSphere(rayOrigin, rayDir, ti.Vector([ 0.5, -0.5, 0.3]), 0.25, rayT)
    rayT, geomNormal = intersectSphere(rayOrigin, rayDir, ti.Vector([ 0.5,  0.5, 0.3]), 0.25, rayT)
    return (rayT, geomNormal)
# @ti.func intersectScene


@ti.func
def sampleUniform(
    u: ti.f32,
    maxDistance: ti.f32
):
    dist = u * maxDistance
    pdf = 1.0 / maxDistance
    return (dist, pdf)
# @ti.func sampleUniform


@ti.func
def sampleScattering(
    u: ti.f32,
    maxDistance: ti.f32
):
    # remap u to account for finite max distance
    ## f32
    minU = ti.exp(-SIGMA * maxDistance)
    a = u*(1.0 - minU) + minU

    # sample with pdf proportional to exp(-sig*d)
    dist = -ti.log(a) / SIGMA
    pdf = SIGMA*a / (1.0 - minU)
    return (dist, pdf)
# @ti.func sampleScattering


@ti.func
def sampleEquiAngular(
    u: ti.f32,
    maxDistance: ti.f32,
    rayOrigin: ti.Vector,   # vec3
    rayDir: ti.Vector,      # vec3
    lightPos: ti.Vector     # vec3
):
    # get coord of closest point to light along(infinite) ray
    delta = dot(lightPos - rayOrigin, rayDir)

    # get distance this point is from light
    D = length(rayOrigin + delta*rayDir - lightPos)

    # get angle of endpoints
    thetaA = ti.atan2(0.0 - delta, D)
    thetaB = ti.atan2(maxDistance - delta, D)

    # take sample
    t = D * ti.tan(mix(thetaA, thetaB, u))
    dist = delta + t
    pdf = D / ((thetaB - thetaA) * (D*D + t*t))
    return (dist, pdf)
# @ti.func sampleEquiAngular


@ti.func
def mainImage(
    iTime: ti.f32, 
    i: ti.i32, 
    j: ti.i32,
    splitCoord: ti.f32
):
    """
    ## input
        t       # iTime
        [i, j]  # fragCoord.xy

    ## output
        fragColor   # fragColor
    """
    fragCoord = ti.Vector([i, j])

    lightPos = ti.Vector([
        0.8 * ti.sin(iTime * 7.0 / 4.0), 
        0.8 * ti.sin(iTime * 5.0 / 4.0), 
        0.0
    ])
    lightIntensity    = vec3(LIGHT_POWER)
    surfIntensity     = vec3(SURFACE_ALBEDO / PI)
    particleIntensity = vec3(1.0 / (4.0*PI))

    rayOrigin = ti.Vector([0.0, 0.0, 5.0])
    rayDir = sampleCamera(fragCoord, ti.Vector([0.5, 0.5]), rayOrigin)

    col = vec3(0.0)
    t = DIST_MAX
    t, n = intersectScene(rayOrigin, rayDir, t)
    if t < DIST_MAX:
        # connect surface to light
        surfPos   = rayOrigin + t*rayDir
        lightVec  = lightPos - surfPos
        lightDir  = normalize(lightVec)
        cameraDir = -rayDir
        nDotL = dot(n, lightDir)
        nDotC = dot(n, cameraDir)

        # only handle BRDF if entry and exit are same hemisphere
        if nDotL*nDotC > 0.0:
            d = length(lightVec)
            t2 = d
            rayDir = normalize(lightVec)
            t2, n2 = intersectScene(surfPos + EPS*rayDir, rayDir, t2)

            # accumulate surface response if not occluded
            if t2 == d:
                trans = ti.exp(-SIGMA * (d + t))
                geomTerm = abs(nDotL) / dot(lightVec, lightVec)
                col = surfIntensity*lightIntensity*geomTerm*trans
            # if t2 == d
        # if nDotL*nDotC > 0.0
    # if t < DIST_MAX 

    offset = hash(fragCoord[1]*w + fragCoord[0] + iTime)

    for stepIndex in range(STEP_COUNT):
        u = (stepIndex+offset) / STEP_COUNT

        # sample along ray from camera to surface
        x, pdf = 0.0, 0.0
        if (fragCoord[0] < splitCoord):
            x, pdf = sampleScattering(u, t)
        else:
            x, pdf = sampleEquiAngular(u, t, rayOrigin, rayDir, lightPos)
        
        # adjust for number of ray samples
        pdf *= STEP_COUNT

        # connect to light and check shadow ray
        particlePos = rayOrigin + x*rayDir
        lightVec = lightPos - particlePos
        d = length(lightVec)
        t2 = d
        t2, n2 = intersectScene(particlePos, normalize(lightVec), t2)

        # accumulate particle response if not occluded
        if t2 == d:
            trans = ti.exp(-SIGMA * (d + x))
            geomTerm = 1.0 / dot(lightVec, lightVec)
            col += SIGMA*particleIntensity*lightIntensity*geomTerm*trans/pdf
        # if (t2 == d) END
    # for stepIndex in range(STEP_COUNT) 

    # show slider position
    if abs(fragCoord[0] - splitCoord) < 1.0:
        col[0] = 1.0
    
    col = pow(col, vec3(1.0/2.0))
    fragColor = col
    return fragColor
# @ti.func mainImage

@ti.func
def genSplitLine():
    iMouse = gui.get_cursor_pos()
    splitCoord = w / 2
    if iMouse[0] != 0.0:
        splitCoord = iMouse[0]
    
    return splitCoord

@ti.kernel
def render(t: ti.f32):
    splitCoord = genSplitLine()
    for i, j in pixels:
        pixels[i, j] = mainImage(t, i, j, splitCoord)
    
    return


def main(output_img=False):
    """
    img = True # 输出 png
    """
    for ts in range(1000000):
        if gui.get_event(ti.GUI.ESCAPE):
            exit()
        
        render(ts)
        gui.set_image(pixels.to_numpy())
        if output_img:
            gui.show(f'frame/{ts:04d}.png')
        else:
            gui.show()


gui = ti.GUI(GUI_TITLE, res=wh)
if __name__ == '__main__':
    # main(img=True)
    main()
