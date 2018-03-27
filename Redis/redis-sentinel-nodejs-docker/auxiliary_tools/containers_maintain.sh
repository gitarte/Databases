#!/bin/bash
trap "exit" INT

case "$1" in
	start)
	salt 'node*' cmd.run 'docker start $(docker ps -a --format "{{.ID}}") && docker ps'
	;;
  	stop)
	salt 'node*' cmd.run 'docker stop $(docker ps -a --format "{{.ID}}") && docker ps'
	;;
  	restart)
	salt 'node*' cmd.run 'docker restart $(docker ps -a --format "{{.ID}}") && docker ps'
	;;
	rm)
	salt 'node*' cmd.run 'docker rm $(docker ps -a --format "{{.ID}}") && docker ps -a'
	;;
	rmi)
	salt 'node*' cmd.run 'docker rmi $(docker images --format "{{.ID}}") && docker images'
	;;
	pull)
	echo "Pulling for node1..."
	salt 'node1*' cmd.run 'docker pull manager:5000/bsk/redis_master && docker pull manager:5000/bsk/redis_sentinel && docker pull manager:5000/bsk/apud'
	echo "Pulling for node2..."
	salt 'node2*' cmd.run 'docker pull manager:5000/bsk/redis_slave  && docker pull manager:5000/bsk/redis_sentinel && docker pull manager:5000/bsk/apud'
	echo "Pulling for node3..."
	salt 'node3*' cmd.run 'docker pull manager:5000/bsk/redis_slave  && docker pull manager:5000/bsk/redis_sentinel && docker pull manager:5000/bsk/apud'
	salt 'node*'  cmd.run 'docker images'
	;;
	*)
    	echo "Usage: $0 {start|stop|restart|rm|rmi|pull}"
esac

