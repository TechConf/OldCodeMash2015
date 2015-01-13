#!/bin/sh
# utility to prepare a custom security provider MBean jar
# for use by WLST offline

# Determine the location of this script...
# Note: this will not work if the script is sourced (. ./prepareCustomProvider.sh)
SCRIPTPATH=`dirname "$0"`
SCRIPTPATH=`cd "${SCRIPTPATH}"; pwd`

# Set the ORACLE_HOME relative to this script...
ORACLE_HOME=`cd "${SCRIPTPATH}/../.." ; pwd`
export ORACLE_HOME

# Set the MW_HOME relative to the ORACLE_HOME...
MW_HOME=`cd "${ORACLE_HOME}/.." ; pwd`
export MW_HOME

# Set the home directories...
. "${SCRIPTPATH}/setHomeDirs.sh"

umask 027

# set up common environment
. "${SCRIPTPATH}/commEnv.sh"

CLASSPATH="${FMWCONFIG_CLASSPATH}"
export CLASSPATH

JVM_ARGS="-Dprod.props.file=${WL_HOME}/.product.properties ${MEM_ARGS} ${CONFIG_JVM_ARGS}"

if [ -d "${JAVA_HOME}" ]; then
 eval "${JAVA_HOME}/bin/java" ${JVM_ARGS} com.oracle.cie.domain.security.SecurityProviderHelper "$@"
else
 exit 1
fi
