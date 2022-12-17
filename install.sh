#!/usr/bin/env bash
set -euo pipefail

# Setup SWAP memory
sudo fallocate -l 500M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Run the virtual machine
exec sudo docker run -d --restart always --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/op-brave-potato:latest
