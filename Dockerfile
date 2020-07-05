FROM jenkins/jenkins:alpine

ARG uid=1500
ARG gid=1500

USER root
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
USER jenkins
