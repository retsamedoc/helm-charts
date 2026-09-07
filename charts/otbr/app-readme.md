# OpenThread Border Router

OpenThread Border Router (OTBR) joins a Thread radio coprocessor to the k3s node's infrastructure network (IPv6 routing, DNS-SD, NAT64, commissioning).

This is not a zero-config app. A stock pod network and ClusterIP Service will not form a Thread network. The pod must sit on the infrastructure LAN via ipvlan, macvlan, or hostNetwork, plus `NET_ADMIN`, `/dev/net/tun`, and a serial device such as `/dev/ttyACM0`. Set `OT_INFRA_IF` to that backbone interface (often `eth0` on a wired k3s node; the image default is `wlan0`).

Primary targets: k3s + Rancher. See the chart README for the required values.
