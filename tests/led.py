#!/usr/bin/env python
import socket
import sys
import base64
import struct
import time
import random
import colorsys

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def pack(R,G,B):
    return struct.pack('BBB', R, G, B)

def send(d):
    sock.sendto(d, ('192.168.250.247', 5000))

def inter(f, t, i, n):
    return round(f + i * (t - f) / n)

def single(c):
    s = '';
    for i in range(1,50):
        s = s + c
    send(s)
    time.sleep(0.1)

def gradient(r1, r2, g1, g2, b1, b2, n):
    s = '';
    for i in range(1,n+1):
        s = s + pack(inter(r1, r2, i, n), inter(g1, g2, i, n), inter(b1, b2, i, n))
    send(s)
    time.sleep(0.1)

def gir(n):
    while True:
        s = '';
        for i in range(1,n+1):
            s = s + pack(random.uniform(1,255), random.uniform(1,255), random.uniform(1,255))
        send(s)
        time.sleep(0.1)

def rainbow(n):
    k = 1
    begin = 1
    while True:
        s = ''
        k = begin
        for i in range(1,n+1):
            (r,g,b) = colorsys.hsv_to_rgb(k / 255.0, 0.8, 0.8)
            s = s + pack(round(r * 255), round(g * 255), round(b * 255))
            k = (k + 3) % 255
        begin = (begin + 23) % 255
        send(s)
        time.sleep(0.2)

def police(cnt):
    for j in range(1,cnt):
        single(pack(128, 0, 0))
        time.sleep(1)
        single(pack(0, 0, 200))
        time.sleep(1)

single(pack(0, 0, 0))
time.sleep(1)
#police(100)
#gradient(1, 255, 128, 1, 33, 1, 50)
#gir(50)
rainbow(50)
