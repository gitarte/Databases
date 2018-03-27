### Create groups and user
```bash
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
passwd oracle
```
### Create directories
```bash
mkdir /u01
mkdir /u02
mkdir /stage
chown -R oracle:oinstall /u01
chown -R oracle:oinstall /u02
chown -R oracle:oinstall /stage/
chmod -R 775 /u01
chmod -R 775 /u02
chmod g+s /u01
chmod g+s /u02
```
Put installation dir ```database``` into ```/stage/```
### Edit /etc/sysctl.conf
```bash
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 1987162112
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586
```
To apply above execute following
```bash
sysctl -p
sysctl -a
```
### Edit /etc/security/limits.conf
```bash
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
```
### Install dependencies 
```bash
yum install -y binutils compat-libcap1 gcc gcc-c++ glibc glibc glibc-devel glibc-devel ksh compat-libstdc++-33 libaio libaio libaio-devel libaio-devel libgcc libgcc libstdc++ libstdc++ libstdc++-devel libstdc++-devel libXi libXi libXtst libXtst make sysstat xauth
yum groupinstall -y "X Window System"
```
### Installation
Login as oracle with X forrwarding (```ssh -H oracle@...```) and execute
```bash
/stage/database/runInstaller
```
You can remove ```/stage``` after successful instalation.
