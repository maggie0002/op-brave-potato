A temporary repo as part of ongoing development. Tested on a Digital Ocean droplet (Docker will need installing on your droplet).

Clone then build and start with:

```
docker build -t bp .

docker run -it --restart always -v bv_pid:/app/pid --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/balena-virt:latest

docker run -it --restart always -v bv_pid:/app/pid --device=/dev/kvm --cap-add=net_admin --network host t1
```

Default cores, disk size and memory will mirror the system that it is running on (using available memory to avoid out of memory errors). Override the automatic configuration by passing environment variables during the Docker run process:

```
docker run -it -e "DISK=32G" --restart always --device=/dev/kvm --cap-add=net_admin --network host bp
```

Available environment variables with examples:

```
CORES=4
DISK=8G
MEM=512M
```

At the moment only one instance can be running at a time. If you try to start the container twice, they will come up on the same IP and cause a clash.

Mount the running virtualised OS locally with the following, where `ip.ip.ip.ip` is the IP address of your remote host (for example your DigitalOcean Droplet IP):

```
ssh -L 22222:10.0.3.10:22222 \
    -L 2375:10.0.3.10:2375 \
    -L 48484:10.0.3.10:48484 \
    root@ip.ip.ip.ip
```

You can then use the Balena CLI to interact with the OS by using the local IP address, for example:

```
balena ssh 127.0.0.1
balena push 127.0.0.1
```

Other ports can me mapped locally, for example to interact with services on the device:

```
ssh -L 80:10.0.3.10:80 \
    root@ip.ip.ip.ip
```

## Install script

```
curl -fsSL https://raw.githubusercontent.com/maggie0002/op-brave-potato/main/install.sh | sudo sh
```
