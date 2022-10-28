#Devops General image for basic operations in k8s-cluster
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install net-tools -y
RUN apt-get install telnet -y
RUN apt-get install mysql-client -y
RUN apt-get install postgresql-client -y
RUN apt-get install -y openssh-client
RUN apt-get install wget -y && \
    apt-get install curl -y && \
    apt-get install vim -y
RUN wget https://github.com/vi/websocat/releases/download/v1.0.0/websocat_1.0.0_amd64.deb -P / && \
    dpkg -i websocat_1.0.0_amd64.deb
RUN apt-get install nginx -y
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;	
RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN useradd -ms /bin/bash DevOps
#COPY GenerateAuthToken.jar  /home/DevOps
COPY generateTokenScript.sh /home/DevOps/generateTokenScript.sh
RUN chown DevOps:DevOps /home/DevOps/*
RUN chmod +x /home/DevOps/generateTokenScript.sh
WORKDIR /home/DevOps
USER DevOps
