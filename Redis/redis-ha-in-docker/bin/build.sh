#!/bin/bash

# CONFIGURE THE ENVIRONMENT
IP1=192.168.122.201
IP2=192.168.122.202
IP3=192.168.122.203
HOST1=node1.localdomain
HOST2=node2.localdomain
HOST3=node3.localdomain

# MANAGER CONF:
MGR_IP=192.168.122.200
MGR_PORT=5000
MGR_HOST=manager.localdomain

# MASTER CONF:
MST_IMAGE=/bsk/redis_master
MST_NAME=redis_master
MST_PORT=6379

# SLAVE CONF:
SLV_IMAGE=/bsk/redis_slave
SLV_NAME=redis_slave
SLV_PORT=$MST_PORT

# SENTINEL CONF:
SEN_IMAGE=/bsk/redis_sentinel
SEN_NAME=redis_sentinel
SEN_PORT=26379

# REDIS COMMON CONF:
MASTERAUTH=stupidpassword3
REQUIREPASS=stupidpassword3

# DOCKER SPECYFIC CONF:
MEMORY=1G
CPUS=1.5

# COMPUTE AUXILIARY VARIABLES
HOSTNAMES="--add-host=$MGR_HOST:$MGR_IP --add-host=$HOST1:$IP1 --add-host=$HOST2:$IP2 --add-host=$HOST3:$IP3"
MST_ENV="-e PORT=$PORT -e MASTERAUTH=$MASTERAUTH -e REQUIREPASS=$REQUIREPASS"
SLV_ENV=$MST_ENV
SEN_ENV="$MST_ENV -e SLVOF=\"$HOST1 $MST_PORT\""

# COMPUTE CONTAINER COMMANDS
MST_RUN= "docker run --cpus $CPUS --memory $MEMORY -d --name $MST_NAME -p $MST_PORT:$MST_PORT $HOSTNAMES $MST_ENV $MGR_HOST:$MGR_PORT $MST_IMAGE"
SLV_RUN= "docker run --cpus $CPUS --memory $MEMORY -d --name $SLV_NAME -p $SLV_PORT:$SLV_PORT $HOSTNAMES $SLV_ENV $MGR_HOST:$MGR_PORT $SLV_IMAGE"
SEN_RUN= "docker run --cpus $CPUS --memory $MEMORY -d --name $SEN_NAME -p $SEN_PORT:$SEN_PORT $HOSTNAMES $SEN_ENV $MGR_HOST:$MGR_PORT $SEN_IMAGE"
MST_PULL="docker pull $MGR_HOST:$MGR_PORT $MST_IMAGE"
SLV_PULL="docker pull $MGR_HOST:$MGR_PORT $SLV_IMAGE"
SEN_PULL="docker pull $MGR_HOST:$MGR_PORT $SEN_IMAGE"

# BUILD IMAGES
cd ../master   && ./build.sh
cd ../slave    && ./build.sh
cd ../sentinel && ./build.sh

# PROPAGATE IMAGES OVER MACHINES
salt -vt 60 "$HOST1" cmd.run "$MST_PULL"
salt -vt 60 "$HOST2" cmd.run "$SLV_PULL"
salt -vt 60 "$HOST3" cmd.run "$SLV_PULL"
salt -vt 60 "$HOST1" cmd.run "$SEN_PULL"
salt -vt 60 "$HOST2" cmd.run "$SEN_PULL"
salt -vt 60 "$HOST3" cmd.run "$SEN_PULL"

# START CLUSTER
salt -vt 60 "$HOST1" cmd.run "$MST_RUN"
salt -vt 60 "$HOST2" cmd.run "$SLV_RUN"
salt -vt 60 "$HOST3" cmd.run "$SLV_RUN"
salt -vt 60 "$HOST1" cmd.run "$SEN_RUN"
salt -vt 60 "$HOST2" cmd.run "$SEN_RUN"
salt -vt 60 "$HOST3" cmd.run "$SEN_RUN"
