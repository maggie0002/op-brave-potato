A temporary repo as part of ongoing development. Tested on a Digital Ocean droplet (Docker will need installing on your droplet).

Sign up for Digital Ocean. Using the button below you will get $200 of free credit for 60 days; plenty to run a powerful virtual device:

<a href="https://www.digitalocean.com/?refcode=c1582aebbcdf&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%202.svg" alt="DigitalOcean Referral Badge" /></a>

You will see a banner at the top of the page indicating that the credit is active and you can continue to the sign up page:

`Free credit active: Get started on DigitalOcean with a $200, 60-day credit for new users.`

Start from pre-built:

```
docker run -it --restart always --cap-add=net_admin --network host ghcr.io/maggie0002/balena-virt-networking:latest
docker run -it --restart always -v bv_pid:/app/pid --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/balena-virt:latest
```

Start additional instances:

```
docker run -it --restart always -v bv_pid:/app/pid --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/balena-virt:latest
```

Clone then build and start with:

```
docker build -t bp .

docker compose up -d
```

Default cores, disk size and memory will mirror the system that it is running on (using available memory to avoid out of memory errors). Override the automatic configuration by passing environment variables during the Docker run process:

```
docker run -it -e "DISK=32G" --restart always -v bv_pid:/app/pid --device=/dev/kvm --cap-add=net_admin --network host ghcr.io/maggie0002/balena-virt:latest
```

Available environment variables with examples:

```
CORES=4
DISK=8G
MEM=512M
```

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

Tailscale is installed by the `install.sh` script. Use `tailscale up --advertise-routes=10.0.3.0/24 --accept-routes` in the VM host to start Tailscale and to detect all running devices.

Then [enable the subnets](https://tailscale.com/kb/1019/subnets/#step-3-enable-subnet-routes-from-the-admin-console) from your Tailscale admin panel.

## Install script

```
curl -fsSL https://raw.githubusercontent.com/maggie0002/op-brave-potato/main/install.sh | sudo sh
```
