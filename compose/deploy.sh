#!/bin/bash
docker stack rm volume-test
docker stack deploy -c ./docker-compose.yaml volume-test 
