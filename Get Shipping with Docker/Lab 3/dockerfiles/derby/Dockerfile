# Derby 10.10.2.0 Docker image is based off taylodl/jdk:1.7
FROM taylodl/jdk:1.7

MAINTAINER Don Taylor https://hub.docker.com/u/taylodl

# Add Derby and Configure
ADD db-derby-10.10.2.0-bin.tar.gz /appl/derby
RUN mkdir /appl/derby/databases
ENV DERBY_HOME /appl/derby/db-derby-10.10.2.0-bin
ENV PATH $PATH:$DERBY_HOME/bin
ENV DERBY_DATABASES /appl/derby/databases

# Expose port 1527 from the Docker container
# It can be mapped to the desired host port when run
# docker run -p <host port>:1527
EXPOSE 1527

# Derby will automatically be started if no parameters
# are passed to docker run
CMD cd $DERBY_DATABASES && java -jar $DERBY_HOME/lib/derbyrun.jar server start -h 0.0.0.0




