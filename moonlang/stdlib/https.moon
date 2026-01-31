# ============================================
# MoonLang 标准库 - HTTPS 服务器
# 用法: from "stdlib/https.moon" import HttpsServer
# ============================================

from "stdlib/http.moon" import Request, Response

# HTTPS 服务器类
# 基于 HTTP 服务器扩展，添加 TLS 支持
class HttpsServer:
    function init(port, certPath, keyPath):
        self.port = port
        self.certPath = certPath
        self.keyPath = keyPath
        self.routes = {}
        self.server = null
    end
    
    # 注册路由
    function route(method, path, handler):
        key = to_upper(method) + " " + path
        self.routes[key] = handler
        return self
    end
    
    # GET 请求
    function get(path, handler):
        return self.route("GET", path, handler)
    end
    
    # POST 请求
    function post(path, handler):
        return self.route("POST", path, handler)
    end
    
    # PUT 请求
    function put(path, handler):
        return self.route("PUT", path, handler)
    end
    
    # DELETE 请求
    function delete(path, handler):
        return self.route("DELETE", path, handler)
    end
    
    # 查找路由处理器
    function _findHandler(method, path):
        key = to_upper(method) + " " + path
        if has_key(self.routes, key):
            return self.routes[key]
        end
        # 尝试通配符路由
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
                res.html("<h1>500 Internal Server Error</h1><p>" + str(err) + "</p>")
            end
        end
        
        return res.build()
    end
    
    # 启动 HTTPS 服务器
    function start():
        self.server = tls_listen(self.port, self.certPath, self.keyPath)
        if self.server == null:
            print("HTTPS Server failed to start - check certificate and key files")
            return false
        end
        
        print("HTTPS Server running at https://127.0.0.1:" + str(self.port))
        print("[DEBUG] Entering main loop...")
        
        running = true
        while running:
            print("[DEBUG] Waiting for connection...")
            clientInfo = tls_accept(self.server)
            
            if clientInfo == null:
                print("[DEBUG] tls_accept returned null, continuing...")
                # 不使用 continue，用循环条件控制
            else:
                print("[DEBUG] Client connected!")
                client = clientInfo["conn"]
                raw = tls_recv(client)
                
                if len(raw) > 0:
                    print("[DEBUG] Received " + str(len(raw)) + " bytes")
                    response = self._handle(raw)
                    tls_send(client, response)
                    print("[DEBUG] Response sent")
                end
                
                tls_close(client)
                print("[DEBUG] Connection closed")
            end
        end
        
        return true
    end
    
    # 停止服务器
    function stop():
        if self.server != null:
            tls_close(self.server)
            self.server = null
        end
    end
end

# HTTPS 客户端类
# 用于发送 HTTPS 请求
class HttpsClient:
    function init():
        self.conn = null
        self.host = ""
        self.port = 443
    end
    
    # 连接到 HTTPS 服务器
    function connect(host, port):
        self.host = host
        self.port = port
        self.conn = tls_connect(host, port)
        return self.conn != null
    end
    
    # 发送 GET 请求
    function get(path, headers):
        if self.conn == null:
            return null
        end
        
        request = "GET " + path + " HTTP/1.1\r\n"
        request = request + "Host: " + self.host + "\r\n"
        
        # 添加自定义头
        if headers != null:
            for key in keys(headers):
                request = request + key + ": " + headers[key] + "\r\n"
            end
        end
        
        request = request + "Connection: close\r\n"
        request = request + "\r\n"
        
        tls_send(self.conn, request)
        return self._readResponse()
    end
    
    # 发送 POST 请求
    function post(path, body, contentType, headers):
        if self.conn == null:
            return null
        end
        
        if contentType == null:
            contentType = "application/x-www-form-urlencoded"
        end
        
        request = "POST " + path + " HTTP/1.1\r\n"
        request = request + "Host: " + self.host + "\r\n"
        request = request + "Content-Type: " + contentType + "\r\n"
        request = request + "Content-Length: " + str(len(body)) + "\r\n"
        
        # 添加自定义头
        if headers != null:
            for key in keys(headers):
                request = request + key + ": " + headers[key] + "\r\n"
            end
        end
        
        request = request + "Connection: close\r\n"
        request = request + "\r\n"
        request = request + body
        
        tls_send(self.conn, request)
        return self._readResponse()
    end
    
    # 发送 JSON POST 请求
    function postJson(path, data, headers):
        body = json_encode(data)
        return self.post(path, body, "application/json", headers)
    end
    
    # 读取响应
    function _readResponse():
        response = ""
        while true:
            chunk = tls_recv(self.conn)
            if len(chunk) == 0:
                break
            end
            response = response + chunk
        end
        
        return self._parseResponse(response)
    end
    
    # 解析 HTTP 响应
    function _parseResponse(raw):
        result = {
            "status": 0,
            "headers": {},
            "body": ""
        }
        
        headerEnd = find(raw, "\r\n\r\n")
        if headerEnd < 0:
            result["body"] = raw
            return result
        end
        
        headerSection = substring(raw, 0, headerEnd)
        result["body"] = substring(raw, headerEnd + 4, len(raw) - headerEnd - 4)
        
        lines = split(headerSection, "\r\n")
        if len(lines) > 0:
            # 解析状态行
            statusLine = lines[0]
            parts = split(statusLine, " ")
            if len(parts) >= 2:
                result["status"] = int(parts[1])
            end
            
            # 解析头
            i = 1
            while i < len(lines):
                line = lines[i]
                if contains(line, ": "):
                    colonPos = find(line, ": ")
                    headerName = substring(line, 0, colonPos)
                    headerValue = substring(line, colonPos + 2, len(line) - colonPos - 2)
                    result["headers"][to_lower(headerName)] = headerValue
                end
                i = i + 1
            end
        end
        
        return result
    end
    
    # 关闭连接
    function close():
        if self.conn != null:
            tls_close(self.conn)
            self.conn = null
        end
    end
end

# 快速 HTTPS GET 请求
function httpsGet(url):
    # 解析 URL
    if not starts_with(url, "https://"):
        return {"error": "URL must start with https://", "status": 0}
    end
    
    # 去除 https://
    remaining = substring(url, 8, len(url) - 8)
    
    # 提取主机和路径
    path = "/"
    host = remaining
    
    slashPos = find(remaining, "/")
    if slashPos >= 0:
        host = substring(remaining, 0, slashPos)
        path = substring(remaining, slashPos, len(remaining) - slashPos)
    end
    
    # 检查端口
    port = 443
    colonPos = find(host, ":")
    if colonPos >= 0:
        portStr = substring(host, colonPos + 1, len(host) - colonPos - 1)
        host = substring(host, 0, colonPos)
        port = int(portStr)
    end
    
    # 发起请求
    client = new HttpsClient()
    if not client.connect(host, port):
        return {"error": "Failed to connect", "status": 0}
    end
    
    result = client.get(path, null)
    client.close()
    
    return result
end

# 快速 HTTPS POST 请求
function httpsPost(url, data, contentType):
    # 解析 URL
    if not starts_with(url, "https://"):
        return {"error": "URL must start with https://", "status": 0}
    end
    
    # 去除 https://
    remaining = substring(url, 8, len(url) - 8)
    
    # 提取主机和路径
    path = "/"
    host = remaining
    
    slashPos = find(remaining, "/")
    if slashPos >= 0:
        host = substring(remaining, 0, slashPos)
        path = substring(remaining, slashPos, len(remaining) - slashPos)
    end
    
    # 检查端口
    port = 443
    colonPos = find(host, ":")
    if colonPos >= 0:
        portStr = substring(host, colonPos + 1, len(host) - colonPos - 1)
        host = substring(host, 0, colonPos)
        port = int(portStr)
    end
    
    # 发起请求
    client = new HttpsClient()
    if not client.connect(host, port):
        return {"error": "Failed to connect", "status": 0}
    end
    
    result = client.post(path, data, contentType, null)
    client.close()
    
    return result
end

# 快速创建 HTTPS 服务器
function createHttpsServer(port, certPath, keyPath):
    return new HttpsServer(port, certPath, keyPath)
end
