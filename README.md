# docker-php-fpm-nginx-postfix
## Introduction
This is a repository that can be used to run php, php-fpm, nginx, postfix on docker / kubernetes. This can be used as a dev environment for developer as well as a base docker image to build other images on top of.
## How to use this
### Changes required to make postfix work
* Make changes to the postfix/sasl_passwd file and update it with your own smtp details
* Make changes to the postfix/main.cf file and update the following lines
    sender_canonical_maps = static:no-reply@nodesol.com
    relayhost = smtp.nodesol.com:587
### Building with docker
    docker build -t nodesol-base:latest .
### Running a docker container for code development
    docker run -d -p 8000:80 --name=nodesol-base -v "$(pwd)":"${DIR}" nodesol-base:latest
