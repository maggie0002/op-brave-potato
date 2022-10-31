#!/usr/bin/env bash
#set -e

mkdir -p /dev/net
mknod -m 666 /dev/net/tun c 10 200

brctl addbr br0
ip addr add 10.0.0.1/16 dev br0 
ip link set dev br0 up

dnsmasq --interface=br0 --dhcp-range="interface:br0,10.0.0.2,10.0.255.254,255.255.0.0" --port=0 --conf-file "" --bind-interfaces --no-daemon &

exec "$@"
