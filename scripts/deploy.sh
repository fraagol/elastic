#!/bin/bash
echo
echo git pull
git pull
echo
echo chmod +x /home/mimacom/elastic/scripts/deploy.sh
chmod +x /home/mimacom/elastic/scripts/deploy.sh
echo
echo docker stack rm volume-test
docker stack rm volume-test
sleep 1

echo
echo docker stack deploy -c ./docker-compose.yaml volume-test 
docker stack deploy -c ./docker-compose.yml volume-test 
sleep 1

echo
echo docker service ls
docker service ls
