#!/bin/bash
docker build -t manager.localdomain:5000/bsk/dave .
docker push     manager.localdomain:5000/bsk/dave
