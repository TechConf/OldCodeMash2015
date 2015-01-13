# Maven 3.2.5 Docker image is based off taylodl/jdk:1.7
FROM taylodl/jdk:1.7

MAINTAINER Don Taylor https://hub.docker.com/u/taylodl

# Add Java and setup Java environment
ADD apache-maven-3.2.5-bin.tar.gz /appl/

# Add maven local repository
ADD m2 /root/.m2

ENV MAVEN_HOME /appl/apache-maven-3.2.5
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/appl/java/jdk1.7.0_51/bin:/appl/apache-maven-3.2.5/bin

CMD /bin/bash -l


