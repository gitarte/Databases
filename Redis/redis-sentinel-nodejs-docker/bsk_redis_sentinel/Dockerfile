#FROM   debian:latest
#EXPOSE 26379
#COPY   ["sentinel.conf", "/etc/redis/sentinel.conf"]
#COPY   ["install.sh",    "/root/install.sh"]
#RUN    bash /root/install.sh
#CMD    ["redis-server",  "/etc/redis/sentinel.conf", "--sentinel"]

FROM   redis:latest
EXPOSE 26379
COPY   ["sentinel.conf", "/etc/redis/sentinel.conf"]
CMD    ["redis-server",  "/etc/redis/sentinel.conf", "--sentinel"]
RUN    set -x && chown -R redis:redis /etc/redis
