# REQUIRES: GUI (WebView2)
# Transparent Window

gui_init()

gui_create("Transparent Widget", 300, 300, {
    "transparent": true,
    "topmost": true,
    "center": true
})

html = "<!DOCTYPE html>
<html>
<head>
    <style>
        html, body { 
            background: transparent !important;
            margin: 0; padding: 0;
            overflow: hidden;
        }
        .widget {
            width: 280px; height: 280px;
            margin: 10px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 24px;
            -webkit-app-region: drag;
            cursor: move;
        }
    </style>
</head>
<body>
    <div class='widget'>Circle Widget</div>
</body>
</html>"

gui_load_html(html)
gui_run()
