import taichi as ti

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)
# ti.core.toggle_advanced_optimization(False)

"""
Deform - holes
Created by inigo quilez - iq/2013
License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

https://www.shadertoy.com/view/4sXGzn
"""
GUI_TITLE = "Deform - holes"
w, h = wh = (640, 360)

pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])


## Shader help func
@ti.func
def clamp(x, minVal, maxVal):
    return min(max(x, minVal), maxVal)


@ti.func
def smoothstep(edge0, edge1, x):
    t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)

@ti.func
def mainImage(
    iMouse: ti.Vector,
    iTime: ti.f32,
    i: ti.i32,
    j: ti.i32
) -> ti.Vector:
    fragCoord = ti.Vector([i, j])

    p = -1.0 + 2.0 * fragCoord / iResolution
    m = -1.0 + 2.0 * iMouse  # iMouse 已经归一化

    a1 = ti.atan2(p[1] - m[1], p[0] - m[0])
    a2 = ti.atan2(p[1] + m[1], p[0] + m[0])
    r1 = ti.sqrt((p - m).dot(p - m))
    r2 = ti.sqrt((p + m).dot(p + m))

    uv = ti.Vector([
        0.2*iTime + (r1-r2)*0.25,
        ti.asin(ti.sin(a1-a2)) / 3.1416
    ])

    w  = ti.exp(-15.0 * r1 * r1) + ti.exp(-15.0 * r2 * r2)
    w += 0.25 * smoothstep(0.93, 1.0, ti.sin(128.0 * uv[0]))
    w += 0.25 * smoothstep(0.93, 1.0, ti.sin(128.0 * uv[1]))

    # 可以使用纹理
    # vec3 col = texture( iChannel0, 0.125*uv ).zyx;
    col = ti.Vector([0.0, 0.0, 0.0])
    fragColor = col + w
    return fragColor


@ti.kernel
def render(
    t: ti.f32,
    mpos_x: ti.f32, 
    mpos_y: ti.f32
):
    iMouse = ti.Vector([mpos_x, mpos_y])
    for i, j in pixels:
        pixels[i, j] = mainImage(iMouse, t, i, j)

    return


gui = ti.GUI(GUI_TITLE, res=wh)
def main(output_img=False):
    for ts in range(1000):
        if gui.get_event(ti.GUI.ESCAPE):
            exit()

        mpos_x, mpos_y = gui.get_cursor_pos()
        render(
            ts * 0.03, 
            mpos_x, mpos_y
        )
        gui.set_image(pixels.to_numpy())
        if output_img:
            gui.show(f'frame/{ts:04d}.png')
        else:
            gui.show()


if __name__ == '__main__':
    # main(output_img=True)
    main()
