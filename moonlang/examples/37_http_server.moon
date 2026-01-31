# REQUIRES: Network (HTTP server)
# HTTP Server example

from "stdlib/http.moon" import HttpServer

server = new HttpServer(3000)

# Index handler
function handle_index(req, res):
    res.html("<h1>Hello World!</h1>")
end

# API handler
function handle_api(req, res):
    res.json({"status": "ok", "data": [1, 2, 3]})
end

# Register routes
server.get("/", handle_index)
server.get("/api/data", handle_api)

print("Server: http://127.0.0.1:3000")
server.start()
