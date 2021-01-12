FROM frrouting/frr:v7.5.0
RUN apk update && apk add tcpdump
COPY vtysh.conf /etc/frr/
COPY daemons /etc/frr/
COPY docker-start /usr/lib/frr/docker-start
COPY frr.conf /etc/frr/
