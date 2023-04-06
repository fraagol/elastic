#!/bin/bash
echo
echo docker stack rm volume-test
docker stack rm volume-test

echo
echo docker stack deploy -c ./docker-compose.yaml volume-test 
docker stack deploy -c ./docker-compose.yaml volume-test 

echo
echo docker service ls
docker service ls
