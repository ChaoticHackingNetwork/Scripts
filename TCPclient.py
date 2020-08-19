# This is a Basic TCP Server
# Updated to Python3

import threading
import socket

# Specifify IP & Port we want Server to listen on
bind_ip = "0.0.0.0"
bind_port = 8000

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

server.bind((bind_ip, bind_port))

# Tell the server to listen with a Maximum backlog of connections set to 2
server.listen(2)

print("[*] Listening on %s%d" % (bind_ip, bind_port))

# Client-Handling Thread
def handle_client(client_socket):

         # Print what the client sends
         request = client_socket.recv(1024)
         print("[*] Recieved: %s" % request)

         # Send back a packet
         client_socket.send("ACK!")

         client_socket.close()

# Put Server ino main loop, Awaiting incoming connections!
while True:

        client,addr = server.accept()

        print("[*] Accepted connection via %s%d" % (addr[0],addr[1]))

        # Spin up our Client Thread to handle incoming Data!
        client_handler = threading.Thread(target=handle_client,args=(client,))
        client_handler.start()
