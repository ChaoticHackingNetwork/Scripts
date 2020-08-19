# This is a simple TCP Client
# Updated to Python3

import socket

target_host = "0.0.0.0" # or hostname
target_port = 8000

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
data = client.recv(4096)
print(data)

