import taichi as ti
import numpy as np
import time

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)

# Equi-Angular Sampling
# https://www.shadertoy.com/view/Xdf3zB
GUI_TITLE = "Empty"
w, h = wh = (640, 360)
pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])

@ti.func
def mainImage(iTime: ti.f32, i: ti.i32, j: ti.i32):
    fragCoord = ti.Vector([i, j])
    uv = fragCoord / iResolution
    uv_xyx = ti.Vector([uv[0], uv[1], uv[0]])
    col = 0.5 + 0.5 * ti.cos(iTime + uv_xyx + ti.Vector([0, 2, 4]))
    fragColor = col
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
