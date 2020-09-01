#!/usr/bin/env python3

import socket

HEADER = 64
PORT = 7675
SERVER = "172.16.1.40" #CHANGE THIS
FORMAT = 'utf-8'
DISCONNECT_MSG = "Uh-Oh we lost one !DISCONNECTED"
ADDR = (SERVER, PORT)

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(ADDR)

def send(msg):
    message = msg.encode(FORMAT)
    msg_length = len(message)
    send_length = str(msg_length).encode(FORMAT)
    send_length += b' ' * (HEADER - len(send_length))
    client.send(send_length)
    client.send(message)
    print(client.recv(4096).decode(FORMAT)

send("Test! Test! Test!")
input()
send("Test! Test!")
input()
send("Test!")

send(DISCONNECT_MSG)

