# REQUIRES: GUI (WebView2)
# WebView2 GUI wrapper DLL
# Compile: moonc webview_easy.moon --shared -o webview_easy.dll

# Message handler
function handle_close(msg):
    if msg == "close":
        gui_quit()
    end
end

# Normal window
export function easy_quick_html(title, html, width, height):
    gui_init()
    options = { "title": title, "width": width, "height": height }
    win = gui_create(options)
    gui_load_html(win, html)
    gui_show(win, true)
    gui_run()
end

# Frameless window
export function easy_quick_frameless(title, html, width, height):
    gui_init()
    options = {
        "title": title, "width": width, "height": height,
        "frameless": true
    }
    win = gui_create(options)
    gui_on_message(handle_close)
    gui_load_html(win, html)
    gui_show(win, true)
    gui_run()
end

# Transparent window
export function easy_quick_transparent(title, html, width, height):
    gui_init()
    options = {
        "title": title, "width": width, "height": height,
        "transparent": true
    }
    win = gui_create(options)
    gui_on_message(handle_close)
    gui_load_html(win, html)
    gui_show(win, true)
    gui_run()
end

print("WebView DLL exports defined")
