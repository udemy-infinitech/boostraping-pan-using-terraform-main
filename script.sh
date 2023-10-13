#!/usr/bin/env bash
until /usr/bin/ping -c1 www.google.com >/dev/null 2>&1; do :; done
/usr/bin/apt update
/usr/bin/apt install openvpn -y
/usr/sbin/openvpn --dev tun1 --ifconfig 10.255.99.1 10.255.99.2 --route 10.10.10.0 255.255.255.0 10.255.99.2 --tun-mtu 1380 &
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
iptables -A FORWARD -p tcp -i tun1 --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1300
