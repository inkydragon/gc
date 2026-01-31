# REQUIRES: GUI (WebView2)
# JS Direct Call Backend

# Define functions callable from JS
function add(argsJson):
    args = json_decode(argsJson)
    a = args[0]
    b = args[1]
    return json_encode({"result": a + b})
end

function getData(argsJson):
    return json_encode({"name": "MoonLang", "version": "1.0"})
end

# Expose functions to JS
gui_expose("add", add)
gui_expose("getData", getData)

gui_init()
gui_create("Expose Test", 400, 300, {"center": true})
gui_load_html("<button onclick='MoonGUI.call(\"add\", [1,2]).then(r=>alert(r))'>Call add(1,2)</button>")
gui_run()
