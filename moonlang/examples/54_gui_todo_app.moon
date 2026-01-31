# REQUIRES: GUI (WebView2)
# Todo App with GUI

gui_init()

gui_create("Todo List", 400, 500, {
    "center": true,
    "resizable": false
})

html = "<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        h1 { color: #333; }
        input { padding: 10px; width: 70%; font-size: 16px; }
        button { padding: 10px 20px; font-size: 16px; }
        ul { list-style: none; padding: 0; }
        li { padding: 10px; background: white; margin: 5px 0; border-radius: 5px; cursor: pointer; }
        li:hover { background: #eee; }
    </style>
</head>
<body>
    <h1>Todo List</h1>
    <input type='text' id='input' placeholder='Enter task...'>
    <button onclick='addTodo()'>Add</button>
    <ul id='list'></ul>
    <script>
        function addTodo() {
            var input = document.getElementById('input');
            var text = input.value.trim();
            if (text) {
                var li = document.createElement('li');
                li.textContent = text;
                li.onclick = function() { this.remove(); };
                document.getElementById('list').appendChild(li);
                input.value = '';
                MoonGUI.send('added:' + text);
            }
        }
    </script>
</body>
</html>"

gui_load_html(html)

function on_message(msg):
    print("Todo: " + msg)
end

gui_on_message(on_message)
gui_run()
