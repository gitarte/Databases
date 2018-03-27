#!/bin/bash
docker build -t manager.localdomain:5000/bsk/redis_sentinel .
docker push     manager.localdomain:5000/bsk/redis_sentinel
