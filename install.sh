#!/usr/bin/env bash
set -euo pipefail

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Run the virtual machine
exec sudo docker run -d --restart always --device=/dev/kvm --cap-add=net_admin --network host bp
