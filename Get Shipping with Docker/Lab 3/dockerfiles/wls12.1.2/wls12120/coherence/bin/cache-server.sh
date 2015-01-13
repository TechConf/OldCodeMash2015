#!/bin/sh

# This will start a cache server

# specify the Coherence installation directory
SCRIPT_PATH="${BASH_SOURCE[0]}";
if([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`
COHERENCE_HOME=`dirname $SCRIPT_PATH`;
popd  > /dev/null

# specify the JVM heap size
MEMORY=512m

if [ ! -f ${COHERENCE_HOME}/bin/cache-server.sh ]; then
  echo "coherence.sh: must be run from the Coherence installation directory."
  exit
fi

if [ -f $JAVA_HOME/bin/java ]; then
  JAVAEXEC=$JAVA_HOME/bin/java
else
  JAVAEXEC=java
fi

if [[ $1 == '-jmx' ]]; then
    JMXPROPERTIES="-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true"
    shift
fi

JAVA_OPTS="-Xms$MEMORY -Xmx$MEMORY $JMXPROPERTIES"

$JAVAEXEC -server -showversion $JAVA_OPTS -cp "$COHERENCE_HOME/lib/coherence.jar" com.tangosol.net.DefaultCacheServer $1
