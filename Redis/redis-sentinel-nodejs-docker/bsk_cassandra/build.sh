#!/bin/bash
docker build -t manager.localdomain:5000/bsk/cassandra .
docker push     manager.localdomain:5000/bsk/cassandra
