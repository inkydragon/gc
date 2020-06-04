import taichi as ti
import time

print(time.strftime("%H:%M:%S, ", time.localtime()), end='')
ti.init(debug=True, arch=ti.cpu)
# ti.init(arch=ti.gpu)
# ti.core.toggle_advanced_optimization(False)

"Basic fractal by @paulofalcao"
GUI_TITLE = "Basic Fractal"
w, h = wh = (640, 360)
pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])


# Convert r, g, b to normalized vec3
@ti.func
def rot(uv: ti.Vector, a: ti.f32):
    return ti.Vector([
        uv[0]*ti.cos(a) - uv[1]*ti.sin(a),
        uv[1]*ti.cos(a) + uv[0]*ti.sin(a)
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
    circleSize = 1.0 / (3.0 * 2.0 ** maxIterations)

    uv = iResolution * 1.0
    uv = -0.5 * (uv - 2.0 * fragCoord) / uv[0]

    # global rotation and zoom
    uv = rot(uv, iTime)
    uv *= ti.sin(iTime) * 0.5 + 1.5

    # mirror, rotate and scale 6 times...
    s = 0.3
    for _ in range(maxIterations):
        uv = abs(uv) - s
        uv = rot(uv, iTime)
        s = s / 2.1

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
