#!/usr/bin/env python
import socket
import sys
import base64
import struct
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def pack(R,G,B):
    return struct.pack('BBB', R, G, B)

def send(d):
    sock.sendto(d, ('192.168.250.247', 5000))

for j in range(1,200):
    s = '';
    for i in range(1,160):
        s = s + pack(0, 0, 0)
    send(s)
    time.sleep(0.1)
    #for i in range(1,10):
    #    s = s + pack(0, 0, 255 - j)
    #send(s)

