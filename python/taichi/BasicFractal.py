import taichi as ti
import time

print(time.strftime("%H:%M:%S, ", time.localtime()), end='')
ti.init(debug=True, arch=ti.cpu)
# ti.init(arch=ti.gpu)
# ti.core.toggle_advanced_optimization(False)

"Basic fractal by @paulofalcao"
GUI_TITLE = "Basic Fractal 1.5"
w, h = wh = (640, 360)
pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])


# Convert r, g, b to normalized vec3
@ti.func
def rot(uv: ti.Vector, a: ti.f32) -> ti.Vector:
    return ti.Vector([
        uv[0]*ti.cos(a) - uv[1]*ti.sin(a),
        uv[0]*ti.sin(a) + uv[1]*ti.cos(a)
    ])


@ti.func
def mainImage(
    iTime: ti.f32,
    i: ti.i32,
    j: ti.i32
) -> ti.Vector:
    fragCoord = ti.Vector([i, j])

    # a nice value for fullscreen is 8
    maxIterations = 6
    circleSize = 0.4
    
    # normalize stuff
    # uv: ti.Vector = (fragCoord *1.0 - 0.5 * iResolution) / w
    uv = ti.Vector([
        (i - 0.5 * w) / w,
        (j - 0.5 * h) / w
    ])

    # global zoom
    uv *= ti.sin(iTime) * 0.5 + 1.5

    # shift, mirror, rotate and scale 6 times...
    for _ in range(maxIterations):
        uv *= 2.1           # <- Scale
        uv  = rot(uv, iTime) # <- Rotate
        uv  = abs(uv)       # <- Mirror
        uv -= 0.5           # <- Shift

    # draw a circle
    c = 0.0
    if uv.norm() > circleSize:
        c = 0.0
    else:
        c = 1.0

    fragColor = ti.Vector([c, c, c])
    return fragColor


@ti.kernel
def render(t: ti.f32):
    for i, j in pixels:
        pixels[i, j] = mainImage(t, i, j)

    return


gui = ti.GUI(GUI_TITLE, res=wh)
def main(output_img=False):
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
    # main(output_img=True)
    main()
