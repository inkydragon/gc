using Taichi

# ti.init()
init()

res = 1280, 720
# pixels = ti.Vector(3, dt=ti.f32, shape=res)
pixels = zeros(Float32, 1280, 720, 3)

"""
@ti.kernel
def paint():
    for i, j in pixels:
        u = i / res[0]
        v = j / res[1]
        pixels[i, j] = [u, v, 0]
"""
@kernel function paint()
    for i, j in pixels
        u = i / res[0]
        v = j / res[1]
        pixels[i, j] = [u, v, 0]
    end
end


"""
gui = ti.GUI('UV', res)
while not gui.get_event(ti.GUI.ESCAPE):
    paint()
    gui.set_image(pixels)
    gui.show()
"""
gui = GUI('UV', res)
while !get_event(gui, ESCAPE)
    paint()
    set_image(gui, pixels)
    show(gui)
end
