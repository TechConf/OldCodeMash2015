#!/bin/sh

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

if [ ! -f ${COHERENCE_HOME}/bin/pof-config-gen.sh ]; then
  echo "pof-config-gen.sh: could not locate the cohernece installation directory."
  exit
fi

export COHERENCE_HOME

if [ -e $JAVA_HOME/bin/java ];then
  JAVA_EXEC="$JAVA_HOME/bin/java"
else
  JAVA_EXEC="`which java`"
  if [ ! -e $JAVA_EXEC ];then
    echo "pof-config-gen.sh: please set JAVA_HOME or add java to your PATH."
    exit
  fi
fi

CLASSPATH="$COHERENCE_HOME/lib/coherence.jar"

# This will start the POF Configuration Generator

# specify the JVM heap size
MEMORY=512m

JAVA_OPTS="-Xms$MEMORY -Xmx$MEMORY $JAVA_OPTS"

$JAVA_EXEC $JAVA_OPTS -cp $CLASSPATH com.tangosol.io.pof.generator.Executor $*
