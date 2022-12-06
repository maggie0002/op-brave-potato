A temporary repo as part of ongoing development. Tested on a Digital Ocean droplet (Docker will need installing on your droplet).

Clone then build and start with:

```
docker build -t bp .

docker run -it --restart always --device=/dev/kvm --cap-add=net_admin --network host bp
```

To use a custom image instead of the default, mount the image in `img/` inside the container (`.zip` files and `.img` files are both supported).

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

Mount the running virtualised OS locally with the following, where `111.111.111.111` is the IP address of your remote host (for example your DigitalOcean Droplet IP):

```
ssh -L 127.0.0.1:22222:10.0.3.101:22222 -L 127.0.0.1:2375:10.0.3.101:2375 -L 127.0.0.1:48484:10.0.3.101:48484 root@111.111.111.111
```

You can then use the Balena CLI to interact with the OS by using the local IP address, for example:

```
balena ssh 127.0.0.1
balena push 127.0.0.1
```

Other ports can me mapped locally, for example to interact with services on the device:

```
ssh -L 127.0.0.1:80:10.0.3.101:80 root@111.111.111.111
```

## Install script

sudo -v ; curl https://.../install.sh | sudo bash
