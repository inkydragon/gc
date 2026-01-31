# REQUIRES: HTTP server + File system
# File Browser application

from "stdlib/http.moon" import HttpServer

INDEX_HTML = read_file("index.html")

server = new HttpServer(8080)

# Index handler function
function handle_index(req, res):
    res.html(INDEX_HTML)
end

# API - List directory
function handle_list(req, res):
    path = req.get("path", ".")
    items = []
    
    for name in list_dir(path):
        fullPath = path + "/" + name
        item = {
            "name": name,
            "isDir": is_dir(fullPath),
            "size": file_size(fullPath) if is_file(fullPath) else 0
        }
        append(items, item)
    end
    
    res.json({"items": items, "path": path})
end

# API - Read file
function handle_read(req, res):
    path = req.get("path", "")
    if exists(path) and is_file(path):
        content = read_file(path)
        res.json({"content": content})
    else:
        res.json({"error": "File not found"})
    end
end

# Register routes
server.get("/", handle_index)
server.get("/api/list", handle_list)
server.get("/api/read", handle_read)

print("File Browser: http://127.0.0.1:8080")
server.start()
