# REQUIRES: GUI (WebView2)
# Bundle resource folders

moon_bundle("assets/")
moon_bundle("ui/")

gui_init()
gui_create("My App", 800, 600, {"center": true})

# Load any HTML from bundled resources
gui_load_url("moon://assets/index.html")

gui_run()
