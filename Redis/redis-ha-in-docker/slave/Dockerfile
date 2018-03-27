FROM   redis:latest
EXPOSE 6379
COPY   ["redis.conf",   "/usr/local/etc/redis/redis.conf"]
CMD    ["redis-server", "/usr/local/etc/redis/redis.conf", "--port=$PORT", "--masterauth=$MASTERAUTH", "--requirepass=$REQUIREPASS", "--slaveof=$SLAVEOF"]
