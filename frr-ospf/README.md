# Docker上のFRRoutingでOSPFを動かしてみる(docker-compose版)
これは、[Docker上のFRRoutingでOSPFを動かしてみる](https://qiita.com/tk_n/items/648e225d06085a0e2530)をdocker-compose化したものです。

```
# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
f7691e525fcd        bridge              bridge              local
5df12997a7cf        host                host                local
315847e7b1fe        none                null                local

# docker-compose build

# docker-compose up -d
Creating network "frr-ospf_net1" with driver "bridge"
Creating network "frr-ospf_net3" with driver "bridge"
Creating network "frr-ospf_net2" with driver "bridge"
Creating frr2    ... done
Creating alpine1 ... done
Creating alpine2 ... done
Creating frr1    ... done

# docker-compose ps
 Name                Command               State   Ports
--------------------------------------------------------
alpine1   /tmp/startup.sh                  Up
alpine2   /tmp/startup.sh                  Up
frr1      /sbin/tini -- /usr/lib/frr ...   Up
frr2      /sbin/tini -- /usr/lib/frr ...   Up

# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
290bf397d481        frr-ospf_frr1       "/sbin/tini -- /usr/…"   About a minute ago   Up 55 seconds                           frr1
4cc1caf909d3        frr-ospf_alpine2    "/tmp/startup.sh"        About a minute ago   Up 57 seconds                           alpine2
f27c8cf0cffd        frr-ospf_alpine1    "/tmp/startup.sh"        About a minute ago   Up 58 seconds                           alpine1
f5645e981387        frr-ospf_frr2       "/sbin/tini -- /usr/…"   About a minute ago   Up 55 seconds                           frr2

# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
f7691e525fcd        bridge              bridge              local
372fdd72db1d        frr-ospf_net1       bridge              local
bf34d1f2aad8        frr-ospf_net2       bridge              local
19266317cbc7        frr-ospf_net3       bridge              local
5df12997a7cf        host                host                local
315847e7b1fe        none                null                local

# docker exec -it frr1 /bin/sh
/ # vtysh

Hello, this is FRRouting (version 7.5_git).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

frr1# show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       F - PBR, f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup

K>* 0.0.0.0/0 [0/0] via 172.18.0.1, eth0, 00:02:06
C>* 1.1.1.1/32 is directly connected, lo, 00:02:05
O   172.18.0.0/16 [110/10] is directly connected, eth0, weight 1, 00:02:05
C>* 172.18.0.0/16 is directly connected, eth0, 00:02:06
O   172.19.0.0/16 [110/10] is directly connected, eth1, weight 1, 00:01:21
C>* 172.19.0.0/16 is directly connected, eth1, 00:02:06
O>* 172.20.0.0/16 [110/20] via 172.19.0.2, eth1, weight 1, 00:01:11

frr1# exit
/ # exit

# docker exec -it alpine1 /bin/sh
/ # ping 172.20.0.2
PING 172.20.0.2 (172.20.0.2): 56 data bytes
64 bytes from 172.20.0.2: seq=0 ttl=62 time=0.248 ms
64 bytes from 172.20.0.2: seq=1 ttl=62 time=0.458 ms
64 bytes from 172.20.0.2: seq=2 ttl=62 time=0.438 ms
64 bytes from 172.20.0.2: seq=3 ttl=62 time=1.632 ms
^C
--- 172.20.0.2 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.248/0.694/1.632 ms

```

