#FROM   debian:latest
#EXPOSE 6379
#COPY   ["redis.conf", "/etc/redis/redis.conf"]
#COPY   ["install.sh", "/root/install.sh"]
#RUN    bash /root/install.sh
#CMD    ["redis-server", "/etc/redis/redis.conf"]

FROM   redis:latest
EXPOSE 6379
COPY   ["redis.conf",   "/etc/redis/redis.conf"]
CMD    ["redis-server", "/etc/redis/redis.conf"]
RUN    set -x && chown -R redis:redis /etc/redis
