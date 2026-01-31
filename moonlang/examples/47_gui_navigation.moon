# REQUIRES: GUI (WebView2)
# Multi-page Navigation

moon_bundle("ui/")
moon_bundle("pages/")

gui_init()
mainWin = gui_create("App", 900, 600, {"center": true})
gui_load_url("moon://ui/index.html")

# Handle page navigation
function onMessage(winId, msg):
    data = json_decode(msg)
    if data != null and get(data, "type", "") == "navigate":
        page = get(data, "page", "")
        if page == "about":
            gui_load_url(mainWin, "moon://pages/about.html")
        elif page == "settings":
            gui_load_url(mainWin, "moon://pages/settings.html")
        elif page == "home":
            gui_load_url(mainWin, "moon://ui/index.html")
        end
    end
end

gui_on_message(mainWin, onMessage)
gui_run()
