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

#Install AWS CLI
RUN apt-get update \
	  && apt-get install -y python-pip \
	  && pip install awscli --upgrade 
	  
#Install Kubernetes kubectl(CLI)
RUN apt-get update \
	  && apt-get install -y apt-transport-https \
	  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
	  && touch /etc/apt/sources.list.d/kubernetes.list \
	  && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
	  && apt-get update \
	  && apt-get install -y kubectl
#Install kubectl config file so that jenkins can manage kubernetes cluster.	  
COPY .kube/config $HOME/.kube/config

ENV PATH="~/.local/bin:$PATH"

USER jenkins

#automatically installing all plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN ls .
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt