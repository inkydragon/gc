# ============================================
# MoonLang 标准库 - TLS/SSL 支持
# 用法: from "stdlib/tls.moon" import TlsClient, TlsServer
# ============================================

# TLS 客户端类
# 支持安全的 HTTPS/TLS 连接
class TlsClient:
    function init():
        self.conn = null
        self.host = ""
        self.port = 443
        self.connected = false
    end
    
    # 连接到 TLS 服务器
    function connect(host, port):
        self.host = host
        self.port = port
        self.conn = tls_connect(host, port)
        if self.conn != null:
            self.connected = true
            return true
        end
        return false
    end
    
    # 设置证书验证模式
    # mode: "none", "peer", "required"
    function setVerify(mode):
        if self.conn == null:
            return false
        end
        return tls_set_verify(self.conn, mode)
    end
    
    # 设置 SNI 主机名
    function setHostname(hostname):
        if self.conn == null:
            return false
        end
        return tls_set_hostname(self.conn, hostname)
    end
    
    # 发送数据
    function send(data):
        if self.conn == null or not self.connected:
            return -1
        end
        return tls_send(self.conn, data)
    end
    
    # 接收数据
    function recv():
        if self.conn == null or not self.connected:
            return ""
        end
        return tls_recv(self.conn)
    end
    
    # 接收所有数据
    function recvAll(maxSize):
        if self.conn == null or not self.connected:
            return ""
        end
        return tls_recv_all(self.conn, maxSize)
    end
    
    # 获取服务器证书信息
    function getPeerCert():
        if self.conn == null:
            return null
        end
        return tls_get_peer_cert(self.conn)
    end
    
    # 获取当前加密套件
    function getCipher():
        if self.conn == null:
            return ""
        end
        return tls_get_cipher(self.conn)
    end
    
    # 获取 TLS 版本
    function getVersion():
        if self.conn == null:
            return ""
        end
        return tls_get_version(self.conn)
    end
    
    # 关闭连接
    function close():
        if self.conn != null:
            tls_close(self.conn)
            self.conn = null
            self.connected = false
        end
    end
    
    # 检查是否已连接
    function isConnected():
        return self.connected
    end
end

# TLS 连接类 (服务端接受的客户端连接)
# 必须定义在 TlsServer 之前，因为 TlsServer.accept() 使用它
class TlsConnection:
    function init(conn):
        self.conn = conn
        self.connected = true
    end
    
    # 发送数据
    function send(data):
        if self.conn == null:
            return -1
        end
        return tls_send(self.conn, data)
    end
    
    # 接收数据
    function recv():
        if self.conn == null:
            return ""
        end
        return tls_recv(self.conn)
    end
    
    # 接收所有数据
    function recvAll(maxSize):
        if self.conn == null:
            return ""
        end
        return tls_recv_all(self.conn, maxSize)
    end
    
    # 获取加密套件
    function getCipher():
        if self.conn == null:
            return ""
        end
        return tls_get_cipher(self.conn)
    end
    
    # 获取 TLS 版本
    function getVersion():
        if self.conn == null:
            return ""
        end
        return tls_get_version(self.conn)
    end
    
    # 关闭连接
    function close():
        if self.conn != null:
            tls_close(self.conn)
            self.conn = null
            self.connected = false
        end
    end
    
    # 检查是否已连接
    function isConnected():
        return self.connected
    end
end

# TLS 服务器类
# 支持安全的 HTTPS/TLS 服务
class TlsServer:
    function init(port, certPath, keyPath):
        self.port = port
        self.certPath = certPath
        self.keyPath = keyPath
        self.server = null
        self.running = false
    end
    
    # 启动服务器
    function start():
        self.server = tls_listen(self.port, self.certPath, self.keyPath)
        if self.server == null:
            print("TLS Server failed to start on port " + str(self.port))
            return false
        end
        self.running = true
        print("TLS Server running on port " + str(self.port))
        return true
    end
    
    # 接受连接
    # 返回: {"conn": TlsConnection, "address": "ip", "port": port}
    function accept():
        if self.server == null:
            return null
        end
        result = tls_accept(self.server)
        if result == null:
            return null
        end
        # 封装连接对象
        client = new TlsConnection(result["conn"])
        return {
            "client": client,
            "address": result["address"],
            "port": result["port"]
        }
    end
    
    # 停止服务器
    function stop():
        if self.server != null:
            tls_close(self.server)
            self.server = null
            self.running = false
        end
    end
    
    # 检查是否运行中
    function isRunning():
        return self.running
    end
end

# 简化的 HTTPS 客户端函数
# 发送简单的 HTTPS GET 请求
function httpsGet(url):
    # 解析 URL
    if not starts_with(url, "https://"):
        return {"error": "URL must start with https://"}
    end
    
    # 去除 https://
    url = substring(url, 8, len(url) - 8)
    
    # 提取主机和路径
    path = "/"
    host = url
    
    slashPos = find(url, "/")
    if slashPos >= 0:
        host = substring(url, 0, slashPos)
        path = substring(url, slashPos, len(url) - slashPos)
    end
    
    # 检查端口
    port = 443
    colonPos = find(host, ":")
    if colonPos >= 0:
        portStr = substring(host, colonPos + 1, len(host) - colonPos - 1)
        host = substring(host, 0, colonPos)
        port = int(portStr)
    end
    
    # 连接并发送请求
    client = new TlsClient()
    if not client.connect(host, port):
        return {"error": "Failed to connect to " + host + ":" + str(port)}
    end
    
    request = "GET " + path + " HTTP/1.1\r\n"
    request = request + "Host: " + host + "\r\n"
    request = request + "Connection: close\r\n"
    request = request + "User-Agent: MoonLang/1.0\r\n"
    request = request + "\r\n"
    
    client.send(request)
    
    # 读取响应
    response = ""
    while true:
        chunk = client.recv()
        if len(chunk) == 0:
            break
        end
        response = response + chunk
    end
    
    client.close()
    
    # 解析响应
    headerEnd = find(response, "\r\n\r\n")
    if headerEnd < 0:
        return {"error": "Invalid response", "raw": response}
    end
    
    headers = substring(response, 0, headerEnd)
    body = substring(response, headerEnd + 4, len(response) - headerEnd - 4)
    
    # 解析状态码
    statusLine = split(headers, "\r\n")[0]
    statusParts = split(statusLine, " ")
    statusCode = 0
    if len(statusParts) >= 2:
        statusCode = int(statusParts[1])
    end
    
    return {
        "status": statusCode,
        "headers": headers,
        "body": body
    }
end

# 升级现有 TCP socket 为 TLS
function wrapClientSocket(socket):
    return tls_wrap_client(socket)
end

function wrapServerSocket(socket, certPath, keyPath):
    return tls_wrap_server(socket, certPath, keyPath)
end
