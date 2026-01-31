# REQUIRES: GUI (WebView2)
# Simplest GUI program

gui_init()

gui_create("Hello GUI", 600, 400, {
    "center": true,
    "devtools": true
})

gui_load_html("<h1 style='text-align:center;margin-top:150px'>Hello MoonLang!</h1>")
gui_run()
