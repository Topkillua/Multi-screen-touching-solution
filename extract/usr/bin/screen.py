#!/usr/bin/python3

import sys
import time
import os

pidvid ,action  = sys.argv[1:]
pid = pidvid[10:14].lower()
vid = pidvid[5:9].lower()
f = open("/var/screen/screen.log", "a")
log = "{ action: " + action + ", pid :" + pid + ", vid: " + vid + ", time: " + time.strftime("%a %b %d %H:%M:%S %Y", time.localtime()) + "} \n"
f.write(log)
f.close()
