#!/usr/bin/env python3
#   ******  **      ** ****     **
#  **////**/**     /**/**/**   /**
# **    // /**     /**/**//**  /**
#/**       /**********/** //** /**
#/**       /**//////**/**  //**/**
#//**    **/**     /**/**   //****
# //****** /**     /**/**    //***
#  //////  //      // //      /// 

import socket
import threading


HEADER = 64
PORT = 7675
SERVER = "172.16.1.40" #CHANGE THIS OR UNCOMMENT THE NEXT LINE
#SERVER = socket.gethostbyname(socket.gethostname())
SPORT = (SERVER, PORT)
FORMAT = 'utf-8'
DISCONNECT_MSG = "Uh-oh We lost one !DISCONNECTED"

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(SPORT)

def handle_client(conn, addr):
    print(f"[NEW CONNECTION] {addr} connected.")

    connected = True
    while connected:
        msg_length = conn.recv(HEADER).decode(FORMAT)
        if msg_length:
            msg_length = int(msg_length)
            msg = conn.recv(msg_length).decode(FORMAT)
            if msg == DISCONNECT_MSG:
                connected = False

            print(f"[{addr}] {msg}")
            conn.send("MSG received!".encode(FORMAT))


    conn.close()



def start():
    server.listen(5)
    print(f"\33[92m[LISTENING]\033[0m Server is listening on {SERVER}")
    while True:
        conn, addr = server.accept()
        thread = threading.Thread(target=handle_client, args=(conn, addr))
        thread.start()
        print(f"[ACTIVE CONNECTIONS] {threading.activeCount() - 1}")

print("\33[92m[OK]\033[0m Server is starting...")
start()

