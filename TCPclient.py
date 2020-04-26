# This is a simple TCP Client
# ** Note This Program is written in Python2.7 **

import socket

target_host = "0.0.0.0" # or hostname
target_port = 8888

# Socket Object
# AF_INET parameter is Standard IPv4 Address
# SOCK_STREAM is indicating that this is a TCP Client
# SOCK_DGRAM is UDP
client =  socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the Client
client.connect((target_host, target_port))

# Sending Data
client.send("GET / HTTP/1.1\r\nHost: google.com\r\n\r\n")

# Recieve Data
Response = client.recv(4096)
print Response
