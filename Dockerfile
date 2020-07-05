FROM jenkins/jenkins:alpine

ARG uid=1500
ARG gid=1500

USER root
RUN  apk update && apk add --no-cache git && rm -rf /var/lib/apt/lists/*
USER jenkins
