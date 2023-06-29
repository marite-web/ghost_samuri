import socket
import tkinter
#I AM A SERVER!!! I!! AM!!! A! SERVER!!!!!!!

ServSock = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

ip = "127.0.0.1"
port = 6024
connections = []

ServSock.bind((ip, port))
while True:
    data, addr = ServSock.recvfrom(1024)
    print(data)

    if addr in connections:
        print("Client Already Connected.")
    else:
        print("New Client Connected.")
        print(addr)
        connections.append(  addr  )

    for i in connections:
        ServSock.sendto(data,i)





