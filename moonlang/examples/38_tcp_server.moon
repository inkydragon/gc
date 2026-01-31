# REQUIRES: Network (TCP)
# TCP Server example

server = tcp_listen(8080)
print("Server started: http://127.0.0.1:8080")

while true:
    client = tcp_accept(server)
    request = tcp_recv(client["socket"])
    
    response = "HTTP/1.1 200 OK\r\n\r\nHello!"
    tcp_send(client["socket"], response)
    tcp_close(client["socket"])
end
