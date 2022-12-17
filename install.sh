#!/usr/bin/env bash
set -euo pipefail

# Setup SWAP memory
fallocate -l 500M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Run the virtual machine
exec sudo docker run -d --restart always --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/op-brave-potato:latest
