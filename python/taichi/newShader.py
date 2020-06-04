import taichi as ti

# ti.init(debug=True, arch=ti.cpu)
ti.init(arch=ti.gpu)

GUI_TITLE = "Empty"
w, h = wh = (640, 360) # GUI 宽高
pixels = ti.Vector(3, dt=ti.f32, shape=wh)
iResolution = ti.Vector([w, h])

@ti.func
def mainImage(iTime: ti.f32, i: ti.i32, j: ti.i32):
    """ C 源代码
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);
    """
    fragCoord = ti.Vector([i, j])

    # Normalized pixel coordinates (from 0 to 1)
    uv = fragCoord / iResolution

    # Time varying pixel color
    uv_xyx = ti.Vector([uv[0], uv[1], uv[0]]) # 暂不支持直接 .xyx
    col = 0.5 + 0.5 * ti.cos(iTime + uv_xyx + ti.Vector([0, 2, 4]))

    # Output to screen
    fragColor = col # 这里 RGB 就够了
    return fragColor

@ti.kernel
def render(t: ti.f32):
    "render 基本不用动，改 mainImage 就可以了"
    for i, j in pixels:
        pixels[i, j] = mainImage(t, i, j)

    return

def main(output_img=False):
    "output_img: 是否输出图片"
    gui = ti.GUI(GUI_TITLE, res=wh)
    for ts in range(1_000_000):
        if gui.get_event(ti.GUI.ESCAPE):
            exit() # 按 ESC 键退出
        
        # render 接受的输入为现实的时间，这里用 ts 计数模拟
        render(ts * 0.03)
        gui.set_image(pixels.to_numpy())
        if output_img:
            # 输出到 frame 文件夹下；4 位顺序命名
            gui.show(f'frame/{ts:04d}.png')
        else:
            gui.show()

if __name__ == '__main__':
    main(output_img=True)
    # main()

"""
# ref: https://forum.taichi.graphics/t/homework-0-new-shader-ffmpeg-gif/469

ffmpeg -framerate 60 -i %04d.png -c:v libx264 -r 30 out.mp4

ffmpeg -ss 00:00 -t 5 -i out.mp4 -vf "fps=25,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 out.gif
"""
