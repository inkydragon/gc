# REQUIRES: GUI (WebView2)
# System Tray example

gui_init()
gui_create("Tray App", 400, 300, {"center": true})
gui_load_html("<h1>Minimize to tray</h1>")

# Create tray icon
gui_tray_create("My App", "")

# Set context menu
gui_tray_set_menu([
    ["Show", null],
    ["-", null],
    ["Exit", null]
])

# Tray click callback
function on_tray(action):
    if action == "click" or action == "Show":
        gui_show(true)
    elif action == "Exit":
        gui_tray_remove()
        gui_quit()
    end
end

gui_tray_on_click(on_tray)

# Hide instead of quit when close button clicked
function on_message(msg):
    if msg == "{\"type\":\"close\"}":
        gui_show(false)
    end
end

gui_on_message(on_message)
gui_run()
