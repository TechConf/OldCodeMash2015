#!/bin/sh
. $MW_HOME/wlserver/server/bin/setWLSEnv.sh
cd $WLS_MYDOMAIN
$JAVA_HOME/bin/java $JAVA_OPTIONS -Xmx1024m -XX:MaxPermSize=256m weblogic.Server
