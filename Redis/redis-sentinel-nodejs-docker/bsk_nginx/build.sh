#!/bin/bash
docker build -t manager.localdomain:5000/bsk/nginx .
docker push     manager.localdomain:5000/bsk/nginx

docker run -d -p 80:80 \
    --name nginx \
    --add-host=manager.localdomain:192.168.122.200 \
    --add-host=bskapp.localdomain:192.168.122.200 \
    --add-host=node1.localdomain:192.168.122.201 \
    --add-host=node2.localdomain:192.168.122.202 \
    --add-host=node3.localdomain:192.168.122.203 \
    manager.localdomain:5000/bsk/nginx
