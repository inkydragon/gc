# REQUIRES: GUI (WebView2)
# Multiple windows

from "stdlib/gui.moon" import Window, run, quit

# Main window
mainWin = new Window({
    "title": "Main Window",
    "width": 600,
    "height": 400,
    "center": true
})
mainWin.create()

mainHtml = "<!DOCTYPE html>
<html>
<body>
    <h1>Main Window</h1>
    <button onclick=\"MoonGUI.send('open_child')\">Open Child</button>
    <button onclick=\"MoonGUI.send('quit')\">Exit</button>
</body>
</html>"
mainWin.loadHTML(mainHtml)

# Child window
childWin = new Window({
    "title": "Child Window",
    "width": 400,
    "height": 300,
    "x": 100,
    "y": 100
})

childHtml = "<!DOCTYPE html>
<html>
<body style='background:#e8f5e9;'>
    <h1>Child Window</h1>
    <button onclick=\"MoonGUI.close()\">Close</button>
</body>
</html>"

# Main window message handler
function on_main_msg(msg):
    if msg == "open_child":
        childWin.create()
        childWin.loadHTML(childHtml)
    elif msg == "quit":
        quit()
    end
end

mainWin.onMessage(on_main_msg)

run()
