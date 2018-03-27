#!/bin/bash
IP0=192.168.122.200
IP1=192.168.122.201
IP2=192.168.122.202
IP3=192.168.122.203
HOST0=manager.localdomain
HOST1=node1.localdomain
HOST2=node2.localdomain
HOST3=node3.localdomain
HOSTNAMES="--add-host=$HOST0:$IP0 --add-host=$HOST1:$IP1 --add-host=$HOST2:$IP2 --add-host=$HOST3:$IP3"

cd ../bsk_app            && ./build.sh 
cd ../bsk_cassandra      && ./build.sh
cd ../bsk_dave           && ./build.sh
cd ../bsk_nginx          && ./build.sh
cd ../bsk_redis_master   && ./build.sh
cd ../bsk_redis_sentinel && ./build.sh
cd ../bsk_redis_slave    && ./build.sh

salt -vt 60 "$HOST1" cmd.run "docker pull $HOST0:5000/bsk/apud"
salt -vt 60 "$HOST2" cmd.run "docker pull $HOST0:5000/bsk/apud"
salt -vt 60 "$HOST3" cmd.run "docker pull $HOST0:5000/bsk/apud"
salt -vt 60 "$HOST1" cmd.run "docker pull $HOST0:5000/bsk/cassandra"
salt -vt 60 "$HOST2" cmd.run "docker pull $HOST0:5000/bsk/cassandra"
salt -vt 60 "$HOST3" cmd.run "docker pull $HOST0:5000/bsk/cassandra"
salt -vt 60 "$HOST1" cmd.run "docker pull $HOST0:5000/bsk/redis_sentinel"
salt -vt 60 "$HOST2" cmd.run "docker pull $HOST0:5000/bsk/redis_sentinel"
salt -vt 60 "$HOST3" cmd.run "docker pull $HOST0:5000/bsk/redis_sentinel"
salt -vt 60 "$HOST1" cmd.run "docker pull $HOST0:5000/bsk/redis_master"
salt -vt 60 "$HOST2" cmd.run "docker pull $HOST0:5000/bsk/redis_slave"
salt -vt 60 "$HOST3" cmd.run "docker pull $HOST0:5000/bsk/redis_slave"

CASSANDRA_A="docker run -d --name cassandra"
CASSANDRA_B="-e CASSANDRA_SEEDS=$IP1,$IP2,$IP3 -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 $HOSTNAMES $HOST0:5000/bsk/cassandra"
salt -vt 60 "$HOST1" cmd.run  "$CASSANDRA_A -e CASSANDRA_BROADCAST_ADDRESS=$IP1 $CASSANDRA_B"
salt -vt 60 "$HOST2" cmd.run  "$CASSANDRA_A -e CASSANDRA_BROADCAST_ADDRESS=$IP2 $CASSANDRA_B"
salt -vt 60 "$HOST3" cmd.run  "$CASSANDRA_A -e CASSANDRA_BROADCAST_ADDRESS=$IP3 $CASSANDRA_B"

REDIS_MST="docker run -d --name redis_master   -p 6379:6379   $HOSTNAMES $HOST0:5000/bsk/redis_master"
REDIS_SLV="docker run -d --name redis_slave    -p 6379:6379   $HOSTNAMES $HOST0:5000/bsk/redis_slave"
REDIS_SEN="docker run -d --name redis_sentinel -p 26379:26379 $HOSTNAMES $HOST0:5000/bsk/redis_sentinel"
salt -vt 60 "$HOST1" cmd.run "$REDIS_MST"
salt -vt 60 "$HOST2" cmd.run "$REDIS_SLV"
salt -vt 60 "$HOST3" cmd.run "$REDIS_SLV"
salt -vt 60 "$HOST1" cmd.run "$REDIS_SEN"
salt -vt 60 "$HOST2" cmd.run "$REDIS_SEN"
salt -vt 60 "$HOST3" cmd.run "$REDIS_SEN"

APP="docker run -d --name apud -p 80:8080 $HOSTNAMES $HOST0:5000/bsk/apud"
salt -vt 60 "$HOST1" cmd.run "$APP"
salt -vt 60 "$HOST2" cmd.run "$APP"
salt -vt 60 "$HOST3" cmd.run "$APP"
