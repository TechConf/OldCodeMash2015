# wls-mydomain Docker image is based off taylodl/wls:12.1.2
FROM taylodl/wls:12.1.2

MAINTAINER Don Taylor https://hub.docker.com/u/taylodl

# Keep this around in case anyone wants to create another domain
ADD create_mydomain.sh $MW_HOME/create_mydomain.sh

# Create domain directories and add tar file
RUN cd $MW_HOME && mkdir -p ./user_projects/domains/mydomain
ENV WLS_MYDOMAIN $MW_HOME/user_projects/domains/mydomain
ADD mydomain.tar.gz $WLS_MYDOMAIN/../
ADD derbyclient.jar $WLS_MYDOMAIN/lib/

# Expose port 7001 from the Docker container
# It can be mapped to the desired host port when run
# docker run -p <host port>:7001
EXPOSE 7001

# WebLogic will automatically be started if no parameters
# are passed to docker run
CMD cd $WLS_MYDOMAIN && ./bin/startWebLogic.sh
