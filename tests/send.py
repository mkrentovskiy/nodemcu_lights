#!/usr/bin/env python
import requests
import base64
import struct

def pack(R,G,B):
    return struct.pack('BBB', R, G, B)

def send(d):
    r = requests.post("http://192.168.252.1:5683/v1/lightseq", data=base64.b64encode(d))
    print(r.status_code, r.reason)

s = '';
for i in range(1,10):
    s = s + pack(i * 10, i * 11, i * 12)
send(s)