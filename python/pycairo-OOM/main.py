import cairo

# with cairo.PDFSurface("v:/test.pdf", 100, 100) as surface:
#     ctx = cairo.Context(surface)
#     for _ in range(5):
#         ctx.show_page()
with cairo.PDFSurface("v:/test.pdf", 144, 144) as surface:
    # surface.show_page()
    cr = cairo.Context(surface)

    cr.save()
    #snippet.draw_func(cr, width, height)
    cr.restore()
    cr.show_page()
    surface.finish()
