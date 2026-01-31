# REQUIRES: GUI (WebView2)
# Desktop Widget

from "stdlib/gui.moon" import Widget

widget = new Widget({
    "title": "Desktop Cat",
    "width": 220,
    "height": 220,
    "singleInstance": true,
    "hideTaskbar": true,
    "showTray": true,
    "topmost": true,
    "trayMenu": [
        ["Show", "show"],
        ["Hide", "hide"],
        ["-", ""],
        ["Exit", "exit"]
    ]
})

widget.start()
gui_load_url("moon://widget.html")
widget.run()
