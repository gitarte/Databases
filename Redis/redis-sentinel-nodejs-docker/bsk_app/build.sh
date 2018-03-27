#!/bin/bash
docker build -t manager.localdomain:5000/bsk/apud .
docker push     manager.localdomain:5000/bsk/apud
