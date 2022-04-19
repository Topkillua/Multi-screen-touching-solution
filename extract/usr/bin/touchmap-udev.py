#!/usr/bin/python3
# -- coding: UTF-8 --
# -- Author: Blues --

import pyudev
import os

context = pyudev.Context()
monitor = pyudev.Monitor.from_netlink(context)
monitor.filter_by(subsystem='hid')
for device in iter(monitor.poll, None):
    if device.driver != "hid-multitouch":
        continue
    if device.action == "add" or device.action == "change":
        os.system("/usr/bin/remap-touchmap")
