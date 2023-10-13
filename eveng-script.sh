#!/bin/bash

apt update
apt install openvpn -y
openvpn  --remote <replace_this_with_ip_address_of_EC2_instance> --dev tun1 --ifconfig 10.255.99.2 10.255.99.1 --tun-mtu 1380 &
echo "200 lab" >> /etc/iproute2/rt_tables
ip route add 0.0.0.0/0 via 10.255.99.1 table lab
ip route add 10.10.10.0/24 dev ens4 table lab
ip rule add from 10.10.10.0/24 to 0.0.0.0/0 table lab
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -p tcp -s 10.10.10.0/24 --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300