#!/usr/bin/env python

import socket

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect("/run/user/1000/yubikey-touch-detector.socket")

while True:
  data = sock.recv(5)
  if data:
    data = data.decode()
    state = 1 if data.endswith("_1") else 0
    text = "󱦃" if state == 1 else ""
    css = "yubikey-touch-detector"

    if state == 1:
      css += " yubikey-touch-detector--active"

    print(f"{{\"state\": {state}, \"text\": \"{text}\", \"class\": \"{css}\"}}", flush=True)
