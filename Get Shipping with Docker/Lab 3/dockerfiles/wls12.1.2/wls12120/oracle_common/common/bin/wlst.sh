#!/bin/sh

mypwd="`pwd`"

case `uname -s` in
Windows_NT*)
  CLASSPATHSEP=\;
;;
CYGWIN*)
  CLASSPATHSEP=\;
;;
*)
  CLASSPATHSEP=:
;;
esac

# Determine the location of this script...
# Note: this will not work if the script is sourced (. ./wlst.sh)
SCRIPTNAME=$0
case ${SCRIPTNAME} in
 /*)  SCRIPTPATH=`dirname "${SCRIPTNAME}"` ;;
  *)  SCRIPTPATH=`dirname "${mypwd}/${SCRIPTNAME}"` ;;
esac

# Set CURRENT_HOME...
CURRENT_HOME=`cd "${SCRIPTPATH}/../.." ; pwd`
export CURRENT_HOME

# Set the MW_HOME relative to the CURRENT_HOME...
MW_HOME=`cd "${CURRENT_HOME}/.." ; pwd`
export MW_HOME

# Set the home directories...
. "${SCRIPTPATH}/setHomeDirs.sh"

# Set the DELEGATE_ORACLE_HOME to CURRENT_HOME if it's not set...
ORACLE_HOME="${DELEGATE_ORACLE_HOME:=${CURRENT_HOME}}"
export DELEGATE_ORACLE_HOME ORACLE_HOME

# Set the directory to get wlst commands from...
COMMON_WLST_HOME="${COMMON_COMPONENTS_HOME}/common/wlst"
WLST_HOME="${COMMON_WLST_HOME}${CLASSPATHSEP}${WLST_HOME}"
export WLST_HOME

# Some scripts in WLST_HOME reference ORACLE_HOME
WLST_PROPERTIES="${WLST_PROPERTIES} -DORACLE_HOME='${ORACLE_HOME}' -DCOMMON_COMPONENTS_HOME='${COMMON_COMPONENTS_HOME}'"
export WLST_PROPERTIES

# Set the WLST extended env...  
if [ -f "${COMMON_COMPONENTS_HOME}"/common/bin/setWlstEnv.sh ] ; then
  . "${COMMON_COMPONENTS_HOME}"/common/bin/setWlstEnv.sh
fi

# Appending additional jar files to the CLASSPATH...
if [ -d "${COMMON_WLST_HOME}/lib" ] ; then
  for file in "${COMMON_WLST_HOME}"/lib/*.jar ; do
    CLASSPATH="${CLASSPATH}${CLASSPATHSEP}${file}"
  done
fi

# Appending additional resource bundles to the CLASSPATH...
if [ -d "${COMMON_WLST_HOME}/resources" ] ; then
  for file in "${COMMON_WLST_HOME}"/resources/*.jar ; do
    CLASSPATH="${CLASSPATH}${CLASSPATHSEP}${file}"
  done 
fi

export CLASSPATH

umask 027

# set up common environment
if [ ! -z "${WLS_NOT_BRIEF_ENV}" ]; then
  if [ "${WLS_NOT_BRIEF_ENV}" = "true" -o  "${WLS_NOT_BRIEF_ENV}" = "TRUE"  ]; then
    WLS_NOT_BRIEF_ENV=
    export WLS_NOT_BRIEF_ENV
  fi
else
    WLS_NOT_BRIEF_ENV=false
    export WLS_NOT_BRIEF_ENV
fi

if [ -f "${WL_HOME}/server/bin/setWLSEnv.sh" ] ; then
  . "${WL_HOME}/server/bin/setWLSEnv.sh"
else
  . "${MW_HOME}/oracle_common/common/bin/commEnv.sh"
fi

CLASSPATH="${CLASSPATH}${CLASSPATHSEP}${FMWLAUNCH_CLASSPATH}${CLASSPATHSEP}${DERBY_CLASSPATH}${CLASSPATHSEP}${DERBY_TOOLS}"
export CLASSPATH

if [ -f "${SCRIPTPATH}/cam_wlst.sh" ] ; then
  . "${SCRIPTPATH}/cam_wlst.sh"
fi


if [ "${WLST_HOME}" != "" ] ; then
  WLST_PROPERTIES="-Dweblogic.wlstHome='${WLST_HOME}' ${WLST_PROPERTIES}"
  export WLST_PROPERTIES
fi

if [ "${WLS_NOT_BRIEF_ENV}" = "" ] ; then
  echo
  echo CLASSPATH=${CLASSPATH}
fi

JVM_ARGS="-Dprod.props.file='${WL_HOME}'/.product.properties ${WLST_PROPERTIES} ${JVM_D64} ${MEM_ARGS} ${CONFIG_JVM_ARGS}"
if [ -d "${JAVA_HOME}" ]; then
 eval '"${JAVA_HOME}/bin/java"' ${JVM_ARGS} weblogic.WLST '"$@"'
else
 exit 1 
fi

