# redis-sentinel-docker
### Host's map
```
192.168.122.200 manager manager.localdomain
192.168.122.201 node1   node1.localdomain
192.168.122.202 node2   node2.localdomain
192.168.122.203 node3   node3.localdomian
```
### Docker registry
- [set-registry] - Follow this instruction to set custom Docker Registry

### Pull required images
```sh
[root@manager ~]# docker pull registry:latest
[root@manager ~]# docker pull debian:latest
[root@manager ~]# docker pull python:latest
[root@manager ~]# docker pull node:6.9.2
[root@manager ~]# docker pull redis:latest
[root@manager ~]# docker pull nginx:latest
[root@manager ~]# docker pull cassandra:latest
```
### Install the environment 
```sh
[root@manager ~]# git clone https://github.com/gitarte/redis-sentinel-nodejs-docker.git^C
[root@manager ~]# cd redis-sentinel-nodejs-docker/auxiliary_tools/
[root@manager auxiliary_tools]# ./build_app.sh
```
### Start load balancer
```sh
[root@manager ~]# docker run -d -p 80:80 \
    --name nginx \
    --add-host=manager.localdomain:192.168.122.200 \
    --add-host=bskapp.localdomain:192.168.122.200 \
    --add-host=node1.localdomain:192.168.122.201 \
    --add-host=node2.localdomain:192.168.122.202 \
    --add-host=node3.localdomain:192.168.122.203 \
    manager.localdomain:5000/bsk/nginx
```
### Populate DB with some dummy data
```sh
[root@manager ~]# pip    install cassandra-driver
[root@manager ~]# pip3.5 install cassandra-driver
[root@manager ~]# cd redis-sentinel-nodejs-docker/auxiliary_tools/
[root@manager auxiliary_tools]# python3.5 cassandra_populator.py 
```
### Enjoy the results 
[set-registry]: <https://github.com/gitarte/CHEAT-SHEET/blob/master/docker/registry.md>
