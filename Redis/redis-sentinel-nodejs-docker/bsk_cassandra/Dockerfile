FROM   cassandra:latest
COPY   ["cassandra.yaml", "/etc/cassandra/cassandra.yaml"]
EXPOSE 7000 7001 7199 9042 9160
CMD    ["cassandra", "-f"]
