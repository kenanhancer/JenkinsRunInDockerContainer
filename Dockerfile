FROM jenkins/jenkins:lts

LABEL maintainer="kenanhancer@gmail.com"

#get rid of admin password setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER root
RUN apt-get update \
      && apt-get upgrade -y \
      && apt-get install -y sudo libltdl-dev \
      && rm -rf /var/lib/apt/lists/* 
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get update \
	  && apt-get install -y python-pip \
	  && pip install awscli --upgrade 

ENV PATH="~/.local/bin:$PATH"

USER jenkins

#automatically installing all plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt