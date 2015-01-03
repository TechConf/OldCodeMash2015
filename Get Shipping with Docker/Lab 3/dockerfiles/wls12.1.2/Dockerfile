# wls12.1.2 Docker image is based off taylodl/jdk:1.7
FROM taylodl/jdk:1.7

MAINTAINER Don Taylor https://hub.docker.com/u/taylodl

# Add WLS and Configure
ADD wls1212_dev.zip /appl/oracle/middleware/wls/wls1212_dev.zip
RUN cd /appl/oracle/middleware/wls && unzip wls1212_dev.zip
RUN cd /appl/oracle/middleware/wls && rm wls1212_dev.zip
ENV MW_HOME /appl/oracle/middleware/wls/wls12120
RUN cd /appl/oracle/middleware/wls/wls12120 && ./configure.sh -silent


