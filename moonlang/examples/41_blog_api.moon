# REQUIRES: HTTP server + Database
# Simple Blog System

from "stdlib/http.moon" import HttpServer
from "stdlib/db.moon" import Database

db = new Database("blog.db")
posts = db.table("posts")

server = new HttpServer(3000)

# Get posts handler function
function handle_get_posts(req, res):
    allPosts = posts.all()
    res.json({"data": allPosts})
end

# Create post handler function
function handle_create_post(req, res):
    data = json_decode(req.body)
    data["created_at"] = date_format(time(), "%Y-%m-%d %H:%M:%S")
    posts.insert(data)
    db.save()
    res.json({"success": true})
end

# Register routes
server.get("/api/posts", handle_get_posts)
server.post("/api/posts", handle_create_post)

print("Blog API: http://127.0.0.1:3000")
server.start()
