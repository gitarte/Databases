### Install PostgreSQL
```bash
yum -y install postgresql postgresql-contrib postgresql-devel postgresql-libs postgresql-server postgresql-static
postgresql-setup initdb
systemctl enable postgresql
systemctl start  postgresql
```
### Edit /var/lib/pgsql/data/pg_hba.conf
```bash
local   all   all                     peer
host    all   all   192.168.43.0/24   md5
host    all   all   127.0.0.1/32      md5
```
### Edit /var/lib/pgsql/data/postgresql.conf
```bash
listen_addresses = '*'
```
Restart PostgreSQL afterwards
```bash
systemctl restart  postgresql
```
### Create new PostgreSQL user and database
First switch into PostgreSQL context and then start the console
```bash
su - postgres
psql
```
Create the user
```sql
create user psqluser with encrypted password 'psqlpass' createdb;
```
Try to connect into new user from elsewhere
```bash
psql -Upsqluser -h192.168.43.20 -p5432 template1
```
You can then create new database
```sql
create database psqldb template template0 encoding='UTF-8';
```
