# ============================================
# MoonScript 标准库 - HTTP 服务器
# 用法: from "stdlib/http.moon" import HttpServer, Request, Response
# ============================================

# HTTP请求解析
class Request:
    function init(raw):
        self.raw = raw
        self.method = ""
        self.path = "/"
        self.query = {}
        self.headers = {}
        self.body = ""
        self._parse()
    end
    
    function _parse():
        lines = split(self.raw, "\r\n")
        if len(lines) == 0:
            return
        end
        
        # 解析请求行: GET /path?query HTTP/1.1
        first = lines[0]
        parts = split(first, " ")
        if len(parts) >= 2:
            self.method = parts[0]
            full_path = parts[1]
            
            # 解析查询参数
            if contains(full_path, "?"):
                qparts = split(full_path, "?")
                self.path = qparts[0]
                if len(qparts) > 1:
                    self._parseQuery(qparts[1])
                end
            else:
                self.path = full_path
            end
        end
        
        # 解析headers
        i = 1
        while i < len(lines):
            line = lines[i]
            if line == "":
                # 空行后是body
                i = i + 1
                break
            end
            if contains(line, ": "):
                hparts = split(line, ": ")
                self.headers[to_lower(hparts[0])] = hparts[1]
            end
            i = i + 1
        end
        
        # 解析body
        while i < len(lines):
            self.body = self.body + lines[i]
            i = i + 1
        end
    end
    
    function _parseQuery(qs):
        pairs = split(qs, "&")
        for pair in pairs:
            if contains(pair, "="):
                kv = split(pair, "=")
                self.query[kv[0]] = kv[1]
            end
        end
    end
    
    function getParam(name, defaultVal):
        return get(self.query, name, defaultVal)
    end
    
    function header(name, defaultVal):
        return get(self.headers, to_lower(name), defaultVal)
    end
end

# HTTP响应构建
class Response:
    function init():
        self.status = 200
        self.statusText = "OK"
        self.headers = {"Content-Type": "text/html; charset=utf-8"}
        self.body = ""
    end
    
    # 设置状态码
    function setStatus(code, text):
        self.status = code
        self.statusText = text
        return self
    end
    
    # 设置header
    function setHeader(name, value):
        self.headers[name] = value
        return self
    end
    
    # 设置内容类型
    function setContentType(ct):
        self.headers["Content-Type"] = ct
        return self
    end
    
    # 设置body
    function setBody(content):
        self.body = content
        return self
    end
    
    # HTML响应
    function html(content):
        self.headers["Content-Type"] = "text/html; charset=utf-8"
        self.body = content
        return self
    end
    
    # JSON响应
    function json(data):
        self.headers["Content-Type"] = "application/json"
        self.body = json_encode(data)
        return self
    end
    
    # 文本响应
    function text(content):
        self.headers["Content-Type"] = "text/plain; charset=utf-8"
        self.body = content
        return self
    end
    
    # 重定向
    function redirect(url):
        self.status = 302
        self.statusText = "Found"
        self.headers["Location"] = url
        return self
    end
    
    # 404错误
    function notFound(msg):
        self.status = 404
        self.statusText = "Not Found"
        self.body = msg
        return self
    end
    
    # 构建响应字符串
    function build():
        result = "HTTP/1.1 " + str(self.status) + " " + self.statusText + "\r\n"
        for key in keys(self.headers):
            result = result + key + ": " + self.headers[key] + "\r\n"
        end
        result = result + "Content-Length: " + str(len(self.body)) + "\r\n"
        result = result + "\r\n"
        result = result + self.body
        return result
    end
end

# HTTP服务器
class HttpServer:
    function init(port):
        self.port = port
        self.routes = {}
        self.server = null
    end
    
    # 注册路由
    function route(method, path, handler):
        key = to_upper(method) + " " + path
        self.routes[key] = handler
        return self
    end
    
    # GET请求
    function get(path, handler):
        return self.route("GET", path, handler)
    end
    
    # POST请求
    function post(path, handler):
        return self.route("POST", path, handler)
    end
    
    # 查找路由
    function _findHandler(method, path):
        key = to_upper(method) + " " + path
        if has_key(self.routes, key):
            return self.routes[key]
        end
        # 尝试通配符
        key = to_upper(method) + " *"
        if has_key(self.routes, key):
            return self.routes[key]
        end
        return null
    end
    
    # 处理请求
    function _handle(raw):
        req = new Request(raw)
        res = new Response()
        
        handler = self._findHandler(req.method, req.path)
        if handler == null:
            res.notFound("<h1>404 Not Found</h1>")
        else:
            try:
                handler(req, res)
            catch err:
                res.setStatus(500, "Internal Server Error")
                res.html("<h1>500 Error</h1><p>" + str(err) + "</p>")
            end
        end
        
        return res.build()
    end
    
    # 启动服务器
    function start():
        self.server = tcp_listen(self.port)
        print("HTTP Server running at http://127.0.0.1:" + str(self.port))
        
        while true:
            client = tcp_accept(self.server)
            raw = tcp_recv(client["socket"])
            
            if len(raw) > 0:
                response = self._handle(raw)
                tcp_send(client["socket"], response)
            end
            
            tcp_close(client["socket"])
        end
    end
    
    # 停止服务器
    function stop():
        if self.server != null:
            tcp_close(self.server)
        end
    end
end

# 快速创建服务器
function createServer(port):
    return new HttpServer(port)
end
