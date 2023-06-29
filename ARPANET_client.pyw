
import socket
import datetime
import time
from threading import Thread
from tkinter import *
from tkinter import ttk
import tkinter as tk
import tkinter.messagebox
import keyboard


global name
global UDPClientSocket





msgFromClient       = "heyo"
bytesToSend         = str.encode(msgFromClient)
#serverAddressPort   = (input('IP: '), input("Port: "))
serverAddressPort   = ('127.0.0.1', 6024)
bufferSize          = 1024

# Create a UDP socket at client side

UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)


name = 'USER' #default
#name = input("What is your name?: ")




root = Tk()

root.title("-ARPANET-")

root.geometry("300x400")


namebox = Entry(root,text="Please Input Name")
namebox.pack()

main = tk.Frame(root)


incometext = Label(main, )
incometext.pack(side = 'top', fill='both', expand=True)


def clearToTextInput(UDPClientSocket, name):
  name = namebox.get()
  print("heyo")
  global msgboxtext
  global tot_messages

  msgboxtext = msgBox.get("1.0","end-1c")
  #tot_messages.append((f'{name}: {msgboxtext}'))

  msgBox.delete("1.0","end")
  print("Message box Text: ", msgboxtext)
  UDPClientSocket.sendto(  ((msgboxtext)+ "{!!!!!!DIVIDER!!!!!!}" + name ).encode()  , serverAddressPort)



main.pack(side="top", fill="both", expand=True)

global msgBox
msgBox = Text(root, height=2, width=33, bg='light grey')
msgBox.pack(side=tk.LEFT)
SendBut = Button(root, text='Send', command= lambda: clearToTextInput(UDPClientSocket, name))
SendBut.pack(side=tk.LEFT)

global tot_messages
tot_messages = []

def running(UDPClientSocket,incometext): #DISPLAYING / Recieving THE SENT MESSAGES!!!!!!!!
  global name
  while True:
    name = namebox.get()
    try:
      time.sleep(0.3)
      print(name)
      msgFromServer = UDPClientSocket.recvfrom(bufferSize)
      msg = msgFromServer[0].decode()
      print("msg:", msg)

      message = msg.split('{!!!!!!DIVIDER!!!!!!}')
      print('message: ',message)
      if message[1] != name:
        print(f' "{message[1]}" Says: {message[0]}'  )

        tot_messages.append((f'{message[1]}: {message[0]}'))
        print("Tot messages: ", tot_messages)

        tempmessage = ""
        if len(tot_messages) <= 8 :
          for i in tot_messages:
            tempmessage += i + '\n\n'
        else:
          print('THERE ARE MORE THEN MESSAGES', len(tot_messages))
          for i in range( (len(tot_messages)-8 ),(len(tot_messages))):
            print("---------------------------------------------")
            print(tempmessage)
            print('---------------------------------------------')
            tempmessage += tot_messages[i] + '\n\n'
            print(i , tot_messages[i])


        print("---------------------------------------------")
        print(tempmessage)
        print('---------------------------------------------')
        incometext['text'] = tempmessage
    except Exception as e :
      raise e
      



for i in range(1):
    t = Thread(target=running, args=(UDPClientSocket,incometext,))
    t.start()

UDPClientSocket.sendto(  (('Logging on.')+ "{!!!!!!DIVIDER!!!!!!}" + name ).encode()  , serverAddressPort)
root.mainloop()


