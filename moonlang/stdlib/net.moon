# ============================================
# MoonScript 标准库 - 网络操作
# 用法: from "stdlib/net.moon" import TcpClient, TcpServer, UdpSocket
# ============================================

# TCP客户端
class TcpClient:
    function init():
        self.socket = null
        self.connected = false
        self.host = ""
        self.port = 0
    end
    
    # 连接服务器
    function connect(host, port):
        self.host = host
        self.port = port
        self.socket = tcp_connect(host, port)
        if self.socket > 0:
            self.connected = true
            return true
        end
        return false
    end
    
    # 发送数据
    function send(data):
        if not self.connected:
            return false
        end
        tcp_send(self.socket, data)
        return true
    end
    
    # 接收数据
    function recv():
        if not self.connected:
            return ""
        end
        return tcp_recv(self.socket)
    end
    
    # 发送并接收
    function request(data):
        self.send(data)
        return self.recv()
    end
    
    # 关闭连接
    function close():
        if self.socket != null:
            tcp_close(self.socket)
            self.connected = false
        end
    end
    
    # HTTP GET请求
    function httpGet(path):
        req = "GET " + path + " HTTP/1.1\r\n"
        req = req + "Host: " + self.host + "\r\n"
        req = req + "Connection: close\r\n"
        req = req + "\r\n"
        return self.request(req)
    end
    
    # HTTP POST请求
    function httpPost(path, body, contentType):
        req = "POST " + path + " HTTP/1.1\r\n"
        req = req + "Host: " + self.host + "\r\n"
        req = req + "Content-Type: " + contentType + "\r\n"
        req = req + "Content-Length: " + str(len(body)) + "\r\n"
        req = req + "Connection: close\r\n"
        req = req + "\r\n"
        req = req + body
        return self.request(req)
    end
end

# TCP服务器
class TcpServer:
    function init(port):
        self.port = port
        self.server = null
        self.running = false
        self.onConnect = null
        self.onData = null
        self.onClose = null
    end
    
    # 设置连接回调
    function onConnection(callback):
        self.onConnect = callback
        return self
    end
    
    # 设置数据回调
    function onMessage(callback):
        self.onData = callback
        return self
    end
    
    # 设置断开回调
    function onDisconnect(callback):
        self.onClose = callback
        return self
    end
    
    # 启动服务器
    function start():
        self.server = tcp_listen(self.port)
        self.running = true
        print("TCP Server listening on port", self.port)
        
        while self.running:
            client = tcp_accept(self.server)
            sock = client["socket"]
            addr = client["address"]
            
            if self.onConnect != null:
                self.onConnect(sock, addr)
            end
            
            data = tcp_recv(sock)
            if len(data) > 0 and self.onData != null:
                response = self.onData(sock, data, addr)
                if response != null:
                    tcp_send(sock, response)
                end
            end
            
            if self.onClose != null:
                self.onClose(sock, addr)
            end
            
            tcp_close(sock)
        end
    end
    
    # 停止服务器
    function stop():
        self.running = false
        if self.server != null:
            tcp_close(self.server)
        end
    end
end

# UDP套接字
class UdpSocket:
    function init():
        self.socket = udp_socket()
        self.bound = false
    end
    
    # 绑定端口
    function bind(port):
        udp_bind(self.socket, port)
        self.bound = true
        return self
    end
    
    # 发送数据
    function send(host, port, data):
        udp_send(self.socket, host, port, data)
        return self
    end
    
    # 接收数据
    function recv():
        return udp_recv(self.socket)
    end
    
    # 关闭
    function close():
        udp_close(self.socket)
    end
end

# UDP服务器 (简化版)
class UdpServer:
    function init(port):
        self.port = port
        self.socket = null
        self.running = false
        self.onMessage = null
    end
    
    # 设置消息回调
    function onData(callback):
        self.onMessage = callback
        return self
    end
    
    # 启动
    function start():
        self.socket = udp_socket()
        udp_bind(self.socket, self.port)
        self.running = true
        print("UDP Server listening on port", self.port)
        
        while self.running:
            packet = udp_recv(self.socket)
            if self.onMessage != null:
                response = self.onMessage(packet["data"], packet["host"], packet["port"])
                if response != null:
                    udp_send(self.socket, packet["host"], packet["port"], response)
                end
            end
        end
    end
    
    # 停止
    function stop():
        self.running = false
        if self.socket != null:
            udp_close(self.socket)
        end
    end
end

# 快捷函数
function httpGet(host, port, path):
    client = new TcpClient()
    client.connect(host, port)
    response = client.httpGet(path)
    client.close()
    return response
end

function tcpConnect(host, port):
    client = new TcpClient()
    client.connect(host, port)
    return client
end

function tcpServer(port):
    return new TcpServer(port)
end

function udpServer(port):
    return new UdpServer(port)
end
