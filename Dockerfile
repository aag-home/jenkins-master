FROM openjdk:8-jdk-alpine

ARG uid=1500
ARG gid=1500
ARG group=jenkins
ARG user=jenkins

# Jenkins version
ENV JENKINS_VERSION 2.243

# Other env variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Enable cross build
#RUN ["cross-build-start"]

# Install dependencies
RUN apk add --no-cache git git-lfs curl

# Get Jenkins
RUN curl -fL -o /opt/jenkins.war https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# Add Jenkins user and group

RUN mkdir -p $JENKINS_HOME \
  && chown ${uid}:${gid} $JENKINS_HOME \
  && addgroup -g ${gid} ${group} \
  && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}
# Disable cross build
#RUN ["cross-build-end"]

# Expose volume
VOLUME ${JENKINS_HOME}

# Working dir
WORKDIR ${JENKINS_HOME}

# Expose ports
EXPOSE 8080 ${JENKINS_SLAVE_AGENT_PORT}

USER ${user}

# Start Jenkins
CMD ["sh", "-c", "java -jar /opt/jenkins.war"]
