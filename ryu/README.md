To build the image
```bash
docker build --rm -f Dockerfile -t gp-ryu .
```
To Run the container
```bash
docker run -it --net=host --rm --name gp-ryu gp-ryu ryu-manager --ofp-tcp-listen-port 6633 ryu.app.simple_switch_13
```
