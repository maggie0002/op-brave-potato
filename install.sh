#!/usr/bin/env bash

# Setup SWAP memory
sudo fallocate -l 500M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Setup and enable UFW
sudo apt-get update
sudo apt-get install ufw -y
sudo ufw allow ssh
echo "y" | sudo ufw enable

# Install Docker
curl -fsSL https://get.docker.com | sudo sh

# Install Tailscale
export TS_ROUTES=10.0.3.0/24
curl -fsSL https://tailscale.com/install.sh | sudo sh
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Run the virtual machine
sudo docker run -d --restart always --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/op-brave-potato:latest
