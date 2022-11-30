A temporary repo as part of ongoing development. Tested on a Digital Ocean droplet (Docker will need installing on your droplet).

Clone then build and start with:

```
docker build -t bp .

docker run -it --device=/dev/kvm --cap-add=net_admin --network host bp

node cli.js
```
