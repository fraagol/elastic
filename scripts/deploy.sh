#!/bin/bash
echo docker stack rm elastic
docker stack rm elastic
sleep 3
echo
echo git pull
git pull
echo
echo chmod +x /home/mimacom/elastic/scripts/deploy.sh
chmod +x /home/mimacom/elastic/scripts/deploy.sh
echo

echo
echo docker stack deploy -c ./docker-compose.yml elastic 
docker stack deploy -c ./docker-compose.yml elastic 
sleep 1

echo
echo docker service ls
docker service ls
