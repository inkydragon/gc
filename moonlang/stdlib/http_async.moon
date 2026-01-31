# ============================================
# MoonScript 标准库 - 异步 HTTP 服务器
# 用法: from "stdlib/http_async.moon" import AsyncHttpServer
# 
# 特性:
#   - 基于协程的高并发模型 (支持百万级连接)
#   - 每连接一协程,自动调度
#   - Keep-Alive 连接复用
#   - 路由匹配 (精确 + 通配符)
#
# 示例:
#   server = new AsyncHttpServer(8080)
#   server.get("/", handle_index)
#   server.get("/api/users", handle_users)
#   server.start()
# ============================================

# HTTP 请求类
class AsyncRequest:
    function init(raw):
        self.raw = raw
        self.method = ""
        self.path = "/"
        self.query = {}
        self.headers = {}
        self.body = ""
        self.version = "HTTP/1.1"
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
        if len(parts) >= 3:
            self.method = parts[0]
            full_path = parts[1]
            self.version = parts[2]
            
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
        elif len(parts) >= 2:
            self.method = parts[0]
            self.path = parts[1]
        end
        
        # 解析 headers
        i = 1
        while i < len(lines):
            line = lines[i]
            if line == "":
                i = i + 1
                break
            end
            if contains(line, ": "):
                colonIdx = find(line, ": ")
                headerName = substring(line, 0, colonIdx)
                headerValue = substring(line, colonIdx + 2, len(line) - colonIdx - 2)
                self.headers[to_lower(headerName)] = headerValue
            end
            i = i + 1
        end
        
        # 解析 body
        bodyParts = []
        while i < len(lines):
            bodyParts = bodyParts + [lines[i]]
            i = i + 1
        end
        self.body = join(bodyParts, "\r\n")
    end
    
    function _parseQuery(qs):
        pairs = split(qs, "&")
        for pair in pairs:
            if contains(pair, "="):
                kv = split(pair, "=")
                if len(kv) >= 2:
                    self.query[kv[0]] = kv[1]
                end
            end
        end
    end
    
    # 获取查询参数
    function param(name, defaultVal):
        return get(self.query, name, defaultVal)
    end
    
    # 获取 header
    function header(name, defaultVal):
        return get(self.headers, to_lower(name), defaultVal)
    end
    
    # 检查是否 Keep-Alive
    function isKeepAlive():
        conn = get(self.headers, "connection", "")
        if to_lower(conn) == "keep-alive":
            return true
        end
        # HTTP/1.1 默认 Keep-Alive
        if contains(self.version, "1.1") and to_lower(conn) != "close":
            return true
        end
        return false
    end
end

# HTTP 响应类
class AsyncResponse:
    function init():
        self.status = 200
        self.statusText = "OK"
        self.headers = {"Content-Type": "text/html; charset=utf-8"}
        self.body = ""
        self.sent = false
    end
    
    # 设置状态码
    function setStatus(code, text):
        self.status = code
        self.statusText = text
        return self
    end
    
    # 简化状态码设置
    function status(code):
        self.status = code
        # 根据状态码设置文本
        if code == 200:
            self.statusText = "OK"
        elif code == 201:
            self.statusText = "Created"
        elif code == 204:
            self.statusText = "No Content"
        elif code == 301:
            self.statusText = "Moved Permanently"
        elif code == 302:
            self.statusText = "Found"
        elif code == 304:
            self.statusText = "Not Modified"
        elif code == 400:
            self.statusText = "Bad Request"
        elif code == 401:
            self.statusText = "Unauthorized"
        elif code == 403:
            self.statusText = "Forbidden"
        elif code == 404:
            self.statusText = "Not Found"
        elif code == 405:
            self.statusText = "Method Not Allowed"
        elif code == 500:
            self.statusText = "Internal Server Error"
        elif code == 502:
            self.statusText = "Bad Gateway"
        elif code == 503:
            self.statusText = "Service Unavailable"
        else:
            self.statusText = "Unknown"
        end
        return self
    end
    
    # 设置 header
    function setHeader(name, value):
        self.headers[name] = value
        return self
    end
    
    # HTML 响应
    function html(content):
        self.headers["Content-Type"] = "text/html; charset=utf-8"
        self.body = content
        return self
    end
    
    # JSON 响应
    function json(data):
        self.headers["Content-Type"] = "application/json; charset=utf-8"
        self.body = json_encode(data)
        return self
    end
    
    # 纯文本响应
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
    
    # 404
    function notFound(msg):
        self.status = 404
        self.statusText = "Not Found"
        self.body = msg
        return self
    end
    
    # 构建响应 (支持 Keep-Alive)
    function build(keepAlive):
        result = "HTTP/1.1 " + str(self.status) + " " + self.statusText + "\r\n"
        
        # 添加 headers
        for key in keys(self.headers):
            result = result + key + ": " + str(self.headers[key]) + "\r\n"
        end
        
        # Content-Length
        result = result + "Content-Length: " + str(len(self.body)) + "\r\n"
        
        # Connection header
        if keepAlive:
            result = result + "Connection: keep-alive\r\n"
            result = result + "Keep-Alive: timeout=30, max=1000\r\n"
        else:
            result = result + "Connection: close\r\n"
        end
        
        result = result + "\r\n"
        result = result + self.body
        return result
    end
end

# 异步 HTTP 服务器
class AsyncHttpServer:
    function init(port):
        self.port = port
        self.routes = {"GET": {}, "POST": {}, "PUT": {}, "DELETE": {}, "PATCH": {}}
        self.middlewares = []
        self.server = null
        self.running = false
        self.keepAliveEnabled = true
        self.keepAliveTimeout = 30000  # 30 秒
        self.maxRequests = 1000        # 单连接最大请求数
        self.stats = {
            "connections": 0,
            "requests": 0,
            "active": 0
        }
    end
    
    # 注册路由 - GET
    function get(path, handler):
        self.routes["GET"][path] = handler
        return self
    end
    
    # 注册路由 - POST
    function post(path, handler):
        self.routes["POST"][path] = handler
        return self
    end
    
    # 注册路由 - PUT
    function put(path, handler):
        self.routes["PUT"][path] = handler
        return self
    end
    
    # 注册路由 - DELETE
    function delete(path, handler):
        self.routes["DELETE"][path] = handler
        return self
    end
    
    # 注册路由 - PATCH
    function patch(path, handler):
        self.routes["PATCH"][path] = handler
        return self
    end
    
    # 添加中间件
    function use(middleware):
        self.middlewares = self.middlewares + [middleware]
        return self
    end
    
    # 启用/禁用 Keep-Alive
    function setKeepAlive(enabled, timeout, maxReqs):
        self.keepAliveEnabled = enabled
        if timeout > 0:
            self.keepAliveTimeout = timeout
        end
        if maxReqs > 0:
            self.maxRequests = maxReqs
        end
        return self
    end
    
    # 查找路由处理器
    function _findHandler(method, path):
        methodRoutes = get(self.routes, method, {})
        
        # 精确匹配
        if has_key(methodRoutes, path):
            return methodRoutes[path]
        end
        
        # 通配符匹配: /api/*
        for routePath in keys(methodRoutes):
            if ends_with(routePath, "*"):
                prefix = substring(routePath, 0, len(routePath) - 1)
                if starts_with(path, prefix):
                    return methodRoutes[routePath]
                end
            end
        end
        
        # 全局通配符
        if has_key(methodRoutes, "*"):
            return methodRoutes["*"]
        end
        
        return null
    end
    
    # 处理单个请求
    function _processRequest(raw):
        req = new AsyncRequest(raw)
        res = new AsyncResponse()
        
        # 执行中间件 (支持函数和类两种形式)
        for mw in self.middlewares:
            # 尝试调用 handle 方法 (类形式)
            try:
                mw.handle(req, res)
            catch err:
                # 否则作为函数调用
                mw(req, res)
            end
            if res.sent:
                return res
            end
        end
        
        # 查找路由
        handler = self._findHandler(req.method, req.path)
        if handler == null:
            res.status(404).html("<h1>404 Not Found</h1><p>Path: " + req.path + "</p>")
        else:
            try:
                handler(req, res)
            catch err:
                res.status(500).html("<h1>500 Internal Server Error</h1><p>" + str(err) + "</p>")
            end
        end
        
        return res
    end
    
    # 处理客户端连接 (协程)
    function _handleClient(client):
        socket = client["socket"]
        requestCount = 0
        
        while true:
            # 接收数据
            raw = tcp_recv(socket)
            
            if len(raw) == 0:
                break
            end
            
            # 处理请求
            res = self._processRequest(raw)
            req = new AsyncRequest(raw)
            requestCount = requestCount + 1
            
            # 判断 Keep-Alive
            keepAlive = self.keepAliveEnabled and req.isKeepAlive() and requestCount < self.maxRequests
            
            # 发送响应
            response = res.build(keepAlive)
            tcp_send(socket, response)
            
            # 非 Keep-Alive 则关闭
            if not keepAlive:
                break
            end
            
            # 让出 CPU
            yield()
        end
        
        tcp_close(socket)
    end
    
    # 启动服务器 (方案1: 每连接一协程)
    function start():
        self.server = tcp_listen(self.port)
        self.running = true
        
        print("========================================")
        print("  AsyncHttpServer running")
        print("  URL: http://127.0.0.1:" + str(self.port))
        print("  Keep-Alive: " + str(self.keepAliveEnabled))
        print("  CPU cores: " + str(num_cpu()))
        print("========================================")
        
        while self.running:
            client = tcp_accept(self.server)
            
            # 启动协程处理客户端 (匿名函数捕获 self 和 client)
            moon (() => self._handleClient(client))
        end
    end
    
    # 启动高性能服务器 (方案2: 事件驱动 + 协程)
    function startHighPerf():
        self.server = tcp_listen(self.port)
        tcp_set_nonblocking(self.server, true)
        self.running = true
        
        print("========================================")
        print("  AsyncHttpServer [HIGH-PERF MODE]")
        print("  URL: http://127.0.0.1:" + str(self.port))
        print("  Keep-Alive: " + str(self.keepAliveEnabled))
        print("  CPU cores: " + str(num_cpu()))
        print("========================================")
        
        sockets = [self.server]
        clientSockets = {}  # socket -> 状态
        
        while self.running:
            # 使用 select 等待事件
            ready = tcp_select(sockets, 100, "read")
            
            for idx in ready:
                sock = sockets[idx]
                
                if sock == self.server:
                    # 新连接
                    client = tcp_accept_nonblocking(self.server)
                    if client != null:
                        newSock = client["socket"]
                        tcp_set_nonblocking(newSock, true)
                        sockets = sockets + [newSock]
                        clientSockets[str(newSock)] = {"requests": 0, "time": time()}
                    end
                else:
                    # 启动协程处理客户端数据 (匿名函数捕获 self, sock, sockets, clientSockets)
                    moon (() => self._handleClientNonBlocking(sock, sockets, clientSockets))
                end
            end
            
            # 清理超时连接
            self._cleanupIdle(sockets, clientSockets)
            
            # 让协程有机会执行
            yield()
        end
    end
    
    # 非阻塞处理客户端
    function _handleClientNonBlocking(sock, sockets, clients):
        raw = tcp_recv_nonblocking(sock)
        
        if raw == null or len(raw) == 0:
            # 连接关闭
            self._removeSocket(sock, sockets, clients)
            return
        end
        
        # 处理请求
        res = self._processRequest(raw)
        req = new AsyncRequest(raw)
        
        # 更新连接状态
        key = str(sock)
        state = get(clients, key, {"requests": 0, "time": time()})
        state["requests"] = state["requests"] + 1
        state["time"] = time()
        clients[key] = state
        
        # 判断 Keep-Alive
        keepAlive = self.keepAliveEnabled and req.isKeepAlive() and state["requests"] < self.maxRequests
        
        # 发送响应
        response = res.build(keepAlive)
        tcp_send(sock, response)
        
        # 非 Keep-Alive 则关闭
        if not keepAlive:
            self._removeSocket(sock, sockets, clients)
        end
    end
    
    # 移除 socket
    function _removeSocket(sock, sockets, clients):
        tcp_close(sock)
        key = str(sock)
        if has_key(clients, key):
            delete_key(clients, key)
        end
        # 从 sockets 列表移除
        newSockets = []
        for s in sockets:
            if s != sock:
                newSockets = newSockets + [s]
            end
        end
        # 注意: MoonLang 无法直接修改参数,需要调用方处理
    end
    
    # 清理空闲连接
    function _cleanupIdle(sockets, clients):
        now = time()
        toRemove = []
        
        for key in keys(clients):
            state = clients[key]
            if now - state["time"] > self.keepAliveTimeout:
                toRemove = toRemove + [int(key)]
            end
        end
        
        for sock in toRemove:
            self._removeSocket(sock, sockets, clients)
        end
    end
    
    # 停止服务器
    function stop():
        self.running = false
        if self.server != null:
            tcp_close(self.server)
        end
        wait_all()
    end
    
    # 获取统计信息
    function getStats():
        return {
            "active_goroutines": num_goroutines(),
            "keep_alive": self.keepAliveEnabled,
            "port": self.port
        }
    end
end

# ============================================
# 辅助函数
# ============================================

# 快速创建服务器
function createAsyncServer(port):
    return new AsyncHttpServer(port)
end

# 静态文件中间件类
class StaticMiddleware:
    function init(basePath):
        self.basePath = basePath
    end
    
    function handle(req, res):
        if starts_with(req.path, self.basePath):
            filePath = "." + req.path
            if exists(filePath) and is_file(filePath):
                content = read_file(filePath)
                ext = extension(filePath)
                
                ct = "application/octet-stream"
                if ext == ".html":
                    ct = "text/html"
                elif ext == ".css":
                    ct = "text/css"
                elif ext == ".js":
                    ct = "application/javascript"
                elif ext == ".json":
                    ct = "application/json"
                elif ext == ".png":
                    ct = "image/png"
                elif ext == ".jpg" or ext == ".jpeg":
                    ct = "image/jpeg"
                elif ext == ".gif":
                    ct = "image/gif"
                elif ext == ".svg":
                    ct = "image/svg+xml"
                elif ext == ".txt":
                    ct = "text/plain"
                end
                
                res.setHeader("Content-Type", ct)
                res.body = content
                res.sent = true
            end
        end
    end
end

# CORS 中间件类
class CorsMiddleware:
    function init(origin):
        self.origin = origin
    end
    
    function handle(req, res):
        res.setHeader("Access-Control-Allow-Origin", self.origin)
        res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
        
        if req.method == "OPTIONS":
            res.status(204)
            res.body = ""
            res.sent = true
        end
    end
end

# 日志中间件类
class LoggerMiddleware:
    function init():
        self.enabled = true
    end
    
    function handle(req, res):
        if self.enabled:
            print("[" + req.method + "] " + req.path)
        end
    end
end

# 工厂函数 (返回处理函数)
function createStaticMiddleware(basePath):
    mw = new StaticMiddleware(basePath)
    return mw
end

function createCorsMiddleware(origin):
    mw = new CorsMiddleware(origin)
    return mw
end

function createLoggerMiddleware():
    mw = new LoggerMiddleware()
    return mw
end
