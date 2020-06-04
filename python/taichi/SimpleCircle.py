import taichi as ti
import time

print(time.strftime("%H:%M:%S, ", time.localtime()), end='')
# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)
# ti.core.toggle_advanced_optimization(False)


GUI_TITLE = "Simple Circle"
w, h = wh = (640, 360)

pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])


## Shader help func
@ti.func
def mix(x, y, a: ti.f32):
    return x*(1-a) + y*a


@ti.func
def clamp(x, minVal, maxVal):
    return min(max(x, minVal), maxVal)


# Convert r, g, b to normalized vec3
@ti.func
def rgb(r, g, b):
    return ti.Vector([r / 255.0, g / 255.0, b / 255.0])


# Draw a circle at vec2 `pos` with radius `rad` and
# color `color`.
@ti.func
def circle(uv, pos, rad, color):
    d = (pos - uv).norm() - rad
    t = clamp(d, 0.0, 1.0)
    return (color, 1.0 - t)


@ti.func
def mainImage(
    iMouse: ti.Vector,
    iTime: ti.f32,
    i: ti.i32,
    j: ti.i32
) -> ti.Vector:
    """
    @author jonobr1 / http://jonobr1.com/
    """
    uv = ti.Vector([i, j])
    center = iResolution * 0.5
    radius = 0.25 * iResolution[1]

    # Background layer
    layer1 = rgb(210.0, 222.0, 228.0)

    # Circle
    red = rgb(225.0, 95.0, 60.0)
    layer2, alpha = circle(uv, center, radius, red)

    # Blend the two
    fragColor = mix(layer1, layer2, alpha)
    return fragColor


@ti.kernel
def render(t: ti.f32):
    _iMouse = gui.get_cursor_pos()
    iMouse = ti.Vector([_iMouse[0], _iMouse[1]])
    for i, j in pixels:
        pixels[i, j] = mainImage(iMouse, t, i, j)

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
