Docker Commands

Build Image
- sudo docker build -t cpn-php .

Run Image
- sudo docker run -d cpn-php

Commit Image
- sudo docker container ls
- sudo docker container commit b343aa4245ed thiagoyou/cpn-php

Tag Image
- sudo docker image tag thiagoyou/cpn-php:latest thiagoyou/cpn-php:latest

Push Image
- sudo docker image push thiagoyou/cpn-php:latest

Stop Containers
- docker stop $(docker ps -a -q)

Remove Containers
- docker rm $(docker ps -a -q)