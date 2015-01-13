#!/bin/sh

# This will start a command line query application

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

# specify the jline installation directory
JLINE_HOME=$COHERENCE_HOME/lib

# specify if the console will also act as a server
STORAGE_ENABLED=false

# specify the JVM heap size
MEMORY=64m


if [ ! -f ${COHERENCE_HOME}/bin/query.sh ]; then
  echo "query.sh: must be run from the Coherence installation directory."
  exit
fi

if [ -f $JAVA_HOME/bin/java ]; then
  JAVAEXEC=$JAVA_HOME/bin/java
else
  JAVAEXEC=java
fi

if [ $STORAGE_ENABLED == "true" ]; then
	echo "** Starting storage enabled console **"
else
	echo "** Starting storage disabled console **"
fi

JAVA_OPTS="-Xms$MEMORY -Xmx$MEMORY -Dtangosol.coherence.distributed.localstorage=$STORAGE_ENABLED"

$JAVAEXEC -server -showversion $JAVA_OPTS -cp "$COHERENCE_HOME/lib/coherence.jar:$JLINE_HOME/jline.jar" com.tangosol.coherence.dslquery.QueryPlus "$@"
