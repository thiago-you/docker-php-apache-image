# Quick Guide
Quick guide to build and run image.

### Build Image

```
docker build -t cpn-php .
```

### Run Image

```
docker run -d cpn-php
```

### Commit Image

Use hash obtained after run image:

```
docker container commit b343aa4245ed thiagoyou/cpn-php
```

### Tag Image

```
docker image tag thiagoyou/cpn-php thiagoyou/cpn-php:latest
```

### Push Image

```
docker image push thiagoyou/cpn-php:latest
```

### Basic Commands
```
# exibe a lista de containers rodando (com o id)
docker ps -a

# roda um container individual
docker run thiagoyou/cpn-php:apache

# para um container (precisa passar o id)
docker stop 831da8dc24a2

# remove um container (precisa passar o id)
docker rm 831da8dc24a2

# para todos os containers
docker stop $(docker ps -a -q)

# remove todos os containers
docker rm $(docker ps -a -q)

# lista as imagens
docker image ls

# remove uma imagem (precisa passar o id)
# pode ser usado com a flag --force
docker image rm 6fa345457042

# remove todas as imagens
# talvez seja necessário executar 2x
docker image rm $(docker image ls -a -q)

# remove as imagens não utilizadas
docker image prune
```
