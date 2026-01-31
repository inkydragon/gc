# REQUIRES: Network (TCP)
# TCP Client example

# Connect to server
sock = tcp_connect("example.com", 80)

# Send HTTP request
request = "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n"
tcp_send(sock, request)

# Receive response
response = tcp_recv(sock)
print(response)

tcp_close(sock)
