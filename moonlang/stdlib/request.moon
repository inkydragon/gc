# ============================================
# MoonLang 标准库 - HTTP/HTTPS 请求客户端
# 支持 RESTful API、文件下载、高并发
# ============================================

# ============================================
# URL 解析函数
# ============================================
function parseUrl(url):
    result = {
        "scheme": "http",
        "host": "",
        "port": 80,
        "path": "/",
        "query": ""
    }
    
    # 解析 scheme
    if starts_with(url, "https://"):
        result["scheme"] = "https"
        result["port"] = 443
        url = substring(url, 8, len(url) - 8)
    elif starts_with(url, "http://"):
        result["scheme"] = "http"
        result["port"] = 80
        url = substring(url, 7, len(url) - 7)
    end
    
    # 分离 path
    slashPos = find(url, "/")
    if slashPos >= 0:
        result["host"] = substring(url, 0, slashPos)
        result["path"] = substring(url, slashPos, len(url) - slashPos)
    else:
        result["host"] = url
        result["path"] = "/"
    end
    
    # 分离 query
    path = result["path"]
    queryPos = find(path, "?")
    if queryPos >= 0:
        result["query"] = substring(path, queryPos + 1, len(path) - queryPos - 1)
        result["path"] = substring(path, 0, queryPos)
    end
    
    # 解析端口
    host = result["host"]
    colonPos = find(host, ":")
    if colonPos >= 0:
        portStr = substring(host, colonPos + 1, len(host) - colonPos - 1)
        result["host"] = substring(host, 0, colonPos)
        result["port"] = int(portStr)
    end
    
    return result
end

# ============================================
# HTTP 响应解析
# ============================================
function parseResponse(raw):
    result = {
        "status": 0,
        "statusText": "",
        "headers": {},
        "body": "",
        "ok": false,
        "error": null
    }
    
    if raw == null or len(raw) == 0:
        result["error"] = "Empty response"
        return result
    end
    
    # 找到 header 和 body 的分界
    headerEnd = find(raw, "\r\n\r\n")
    if headerEnd < 0:
        result["error"] = "Invalid HTTP response"
        return result
    end
    
    headerPart = substring(raw, 0, headerEnd)
    result["body"] = substring(raw, headerEnd + 4, len(raw) - headerEnd - 4)
    
    # 解析 headers
    lines = split(headerPart, "\r\n")
    if len(lines) == 0:
        result["error"] = "Empty headers"
        return result
    end
    
    # 状态行: HTTP/1.1 200 OK
    statusLine = lines[0]
    parts = split(statusLine, " ")
    if len(parts) >= 2:
        result["status"] = int(parts[1])
        if len(parts) >= 3:
            result["statusText"] = parts[2]
        end
    end
    
    # 解析 header 字段
    i = 1
    while i < len(lines):
        line = lines[i]
        colonPos = find(line, ": ")
        if colonPos > 0:
            key = to_lower(substring(line, 0, colonPos))
            value = substring(line, colonPos + 2, len(line) - colonPos - 2)
            result["headers"][key] = value
        end
        i = i + 1
    end
    
    status = result["status"]
    result["ok"] = status >= 200 and status < 300
    return result
end

# ============================================
# 核心请求函数
# ============================================

# 构建 HTTP 请求
function buildRequest(method, host, path, headers, body):
    req = method + " " + path + " HTTP/1.1\r\n"
    req = req + "Host: " + host + "\r\n"
    req = req + "User-Agent: MoonLang/1.0\r\n"
    req = req + "Accept: */*\r\n"
    req = req + "Connection: close\r\n"
    
    if headers != null:
        for key in keys(headers):
            req = req + key + ": " + str(headers[key]) + "\r\n"
        end
    end
    
    if body != null and len(body) > 0:
        req = req + "Content-Length: " + str(len(body)) + "\r\n"
    end
    
    req = req + "\r\n"
    
    if body != null:
        req = req + body
    end
    
    return req
end

# 发送 HTTP 请求 (明文)
function sendHttp(host, port, request):
    sock = tcp_connect(host, port)
    if sock == null:
        return {"error": "Connection failed", "ok": false, "status": 0, "body": ""}
    end
    
    tcp_send(sock, request)
    
    response = ""
    while true:
        chunk = tcp_recv(sock)
        if chunk == null or len(chunk) == 0:
            break
        end
        response = response + chunk
    end
    
    tcp_close(sock)
    return parseResponse(response)
end

# 发送 HTTPS 请求 (TLS)
function sendHttps(host, port, request):
    conn = tls_connect(host, port)
    if conn == null:
        return {"error": "TLS connection failed", "ok": false, "status": 0, "body": ""}
    end
    
    tls_send(conn, request)
    
    response = ""
    while true:
        chunk = tls_recv(conn)
        if chunk == null or len(chunk) == 0:
            break
        end
        response = response + chunk
    end
    
    tls_close(conn)
    return parseResponse(response)
end

# ============================================
# 主要请求函数
# ============================================

# GET 请求
function httpGet(url, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    query = urlInfo["query"]
    
    if query != "":
        path = path + "?" + query
    end
    
    req = buildRequest("GET", host, path, headers, null)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# POST 请求 (JSON)
function httpPost(url, data, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    
    body = ""
    if data != null:
        body = json_encode(data)
    end
    
    if headers == null:
        headers = {}
    end
    headers["Content-Type"] = "application/json"
    
    req = buildRequest("POST", host, path, headers, body)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# POST 表单
function httpPostForm(url, formData, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    
    # 编码表单
    parts = []
    for key in keys(formData):
        parts = append(parts, key + "=" + str(formData[key]))
    end
    body = join(parts, "&")
    
    if headers == null:
        headers = {}
    end
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    
    req = buildRequest("POST", host, path, headers, body)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# PUT 请求
function httpPut(url, data, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    
    body = ""
    if data != null:
        body = json_encode(data)
    end
    
    if headers == null:
        headers = {}
    end
    headers["Content-Type"] = "application/json"
    
    req = buildRequest("PUT", host, path, headers, body)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# DELETE 请求
function httpDelete(url, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    
    req = buildRequest("DELETE", host, path, headers, null)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# PATCH 请求
function httpPatch(url, data, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    
    body = ""
    if data != null:
        body = json_encode(data)
    end
    
    if headers == null:
        headers = {}
    end
    headers["Content-Type"] = "application/json"
    
    req = buildRequest("PATCH", host, path, headers, body)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# POST 原始数据 (不做 JSON 编码)
function httpPostRaw(url, rawData, headers):
    urlInfo = parseUrl(url)
    host = urlInfo["host"]
    port = urlInfo["port"]
    path = urlInfo["path"]
    
    if headers == null:
        headers = {}
    end
    
    req = buildRequest("POST", host, path, headers, rawData)
    
    if urlInfo["scheme"] == "https":
        return sendHttps(host, port, req)
    else:
        return sendHttp(host, port, req)
    end
end

# ============================================
# 便捷函数
# ============================================

# 获取 JSON 数据
function fetchJson(url):
    resp = httpGet(url, null)
    if resp["ok"]:
        return json_decode(resp["body"])
    end
    return null
end

# 下载文件
function download(url, savePath):
    resp = httpGet(url, null)
    if resp["ok"]:
        write_file(savePath, resp["body"])
        return {"ok": true, "path": savePath, "size": len(resp["body"])}
    end
    return {"ok": false, "error": resp["error"]}
end

# ============================================
# 带认证的请求
# ============================================

# 带 Bearer Token 的 GET
function httpGetWithAuth(url, token):
    headers = {"Authorization": "Bearer " + token}
    return httpGet(url, headers)
end

# 带 Bearer Token 的 POST
function httpPostWithAuth(url, data, token):
    headers = {"Authorization": "Bearer " + token}
    return httpPost(url, data, headers)
end

# ============================================
# 高并发请求 - 需要用户在调用处使用 moon + channel
# ============================================

# 注意: MoonLang 的 moon 关键字不支持跨模块调用
# 因此 parallelGet 需要在用户代码中直接使用 channel 模式
# 
# 示例用法:
# ```
# from "stdlib/request.moon" import httpGet
# 
# function worker(ch, url):
#     resp = httpGet(url, null)
#     ch <- resp
# end
# 
# ch = chan()
# moon worker(ch, "https://api.example.com/1")
# moon worker(ch, "https://api.example.com/2")
# 
# r1 = <- ch
# r2 = <- ch
# ```
