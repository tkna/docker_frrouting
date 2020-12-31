#!/bin/sh

route add default gw 172.20.0.3
route del default gw 172.20.0.1
tail -f /dev/null
