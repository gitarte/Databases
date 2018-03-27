#useradd redis
#mkdir /etc/redis
mkdir /var/lib/redis
mkdir /var/log/redis
chown -R redis:redis /etc/redis
chown -R redis:redis /var/lib/redis
chown -R redis:redis /var/log/redis
#apt-get update && apt-get -y install build-essential tcl8.5 wget
#wget --directory-prefix=/root http://download.redis.io/releases/redis-3.2.5.tar.gz
#cd /root/
#tar xvzf redis-3.2.5.tar.gz
#cd redis-3.2.5/deps
#make hiredis jemalloc linenoise lua geohash-int
#cd ..
#make && make install
#cd /root/
#rm -rf /root/redis-3.2.5*
rm -rf /root/install.sh
