import taichi as ti
import numpy as np
import time

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)

GUI_TITLE = "Red Circle"
w, h = wh = (640, 360)
# w, h = wh = (360, 640)
pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])


@ti.func
def mainImage(iTime: ti.f32, i: ti.i32, j: ti.i32):
    fragCoord = ti.Vector([i, j])
    uv = (2.0 * fragCoord - wh) / min(w, h)
    len = uv.norm()

    fragColor = ti.Vector([0.0, 0.0, 0.0])
    if len <= 0.5:
        fragColor = ti.Vector([1.0, 0.0, 0.0])

    return fragColor


@ti.kernel
def render(t: ti.f32):
    for i, j in pixels:
        pixels[i, j] = mainImage(t, i, j)

    return


def main(output_img=False):
    gui = ti.GUI(GUI_TITLE, res=wh)
    for ts in range(1000000):
        if gui.get_event(ti.GUI.ESCAPE):
            exit()

        render(ts * 0.03)
        gui.set_image(pixels.to_numpy())
        if output_img:
            gui.show(f'frame/{ts:04d}.png')
        else:
            gui.show()


if __name__ == '__main__':
    # main(img=True)
    main()
