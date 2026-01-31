# REQUIRES: GUI (WebView2)
# Window Class + moon_bundle

from "stdlib/gui.moon" import Window, run

moon_bundle("ui/")
moon_bundle("pages/")

mainWin = new Window({
    "title": "My App",
    "width": 900,
    "height": 600,
    "frameless": true,
    "center": true
})
mainWin.create()

mainWin.loadURL("moon://ui/index.html")

function handleNav(msg):
    data = json_decode(msg)
    if data != null and get(data, "type", "") == "navigate":
        page = get(data, "page", "")
        mainWin.loadURL("moon://pages/" + page + ".html")
    end
end

mainWin.onMessage(handleNav)
run()
