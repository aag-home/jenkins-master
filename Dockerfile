FROM openjdk:8-jdk-alpine

ARG uid=1500
ARG gid=1500
ARG group=jenkins
ARG user=jenkins
ARG PLUGINS

# Jenkins version
ENV JENKINS_VERSION 2.254

# Other env variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_WAR /opt/jenkins.war
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JENKINS_UC https://updates.jenkins.io
ENV CASC_JENKINS_CONFIG=$JENKINS_HOME/jenkins.yaml
ENV REF /usr/share/jenkins/ref
ENV JAVA_OPTS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
ENV COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log

# Enable cross build
#RUN ["cross-build-start"]

# Install dependencies
RUN apk add --no-cache git git-lfs curl fontconfig ttf-dejavu coreutils bash unzip

# Get Jenkins

# Add preinstalled plugins
RUN curl -fL -o $JENKINS_WAR https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war && \  
    curl -fL -o /usr/local/bin/install-plugins.sh https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh && \
    curl -fL -o /usr/local/bin/jenkins.sh https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh && \
    curl -fL -o /usr/local/bin/plugins.sh https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh && \
    curl -fL -o /usr/local/bin/jenkins-support https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support && \
    chmod +x /usr/local/bin/install-plugins.sh /usr/local/bin/jenkins.sh /usr/local/bin/plugins.sh /usr/local/bin/jenkins-support && \
    /usr/local/bin/install-plugins.sh configuration-as-code configuration-as-code-support git display-url-api:2.3.2 ${PLUGINS}

# Add Jenkins user and group

RUN mkdir -p $JENKINS_HOME \
  && mkdir -p $REF \
  && chown -R ${uid}:${gid} $JENKINS_HOME \
  && chown -R ${uid}:${gid} $REF \
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
CMD ["/usr/local/bin/jenkins.sh"]
