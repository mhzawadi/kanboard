# Kanboard
<p align="center"><a href="https://hub.docker.com/r/mhzawadi/kanboard"><img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/mhzawadi/kanboard.svg"></a></p>

Kanboard is project management software that focuses on the Kanban methodology.

## How to use this Docker image

### kanboard

```bash
$ docker run -ti -d -p 80:80 --name kanboard --link kanboard-mysql:mysql mhzawadi/kanboard
```

We expose the HTTP port with a host URL of 127.0.0.1, all the data is stored in an sqlite database.

### Docker compose

You can get an all-in-one YAML deployment descriptor with Docker compose, like this :

```
curl https://github.com/mhzawadi/kanboard/blob/master/docker-compose.yml
docker-compose up -d
```

If your using docker swarm you can get a stack that has the same setup:

```
curl https://github.com/mhzawadi/kanboard/blob/master/stack-kanboard.yml
docker stack deploy --compose-file stack-kanboard.yml kanboard
```

### persistent config

if you run docker swarm, you can add your config to docker swarm config and have it persist across containers.

Mount your config to `/var/www/html/ipconfig.php`

### Environment variables summary

- DB_DRIVER: the type of database to use
- MYSQL_HOST: the MySQL server
- MYSQL_USER: the username for MySQL
- MYSQL_PASSWORD: the password for MySQL
- MYSQL_DB: the MySQL database
- MYSQL_PORT: the MySQL port, if not 3306

## Docker hub tags

You can use following tags on Docker hub:

* `latest` - latest stable release
* `v1.5.9.1` - latest stable release for the 1.5.9 version build number 1

### how to build

Latest is build from the docker hub once I push to the github repo, the arm versions are built from my mac with the below buildx tool

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mhzawadi/kanboard:v1.5.10.1 --push .`
