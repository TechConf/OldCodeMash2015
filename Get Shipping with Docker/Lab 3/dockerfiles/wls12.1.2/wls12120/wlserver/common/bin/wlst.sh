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

# Set common components home....
COMMON_COMPONENTS_HOME="${MW_HOME}/oracle_common"
if [ -d "${COMMON_COMPONENTS_HOME}" ] ; then
  COMMON_COMPONENTS_HOME=`cd "${MW_HOME}/oracle_common" ; pwd`
fi
export COMMON_COMPONENTS_HOME

# Set the DELEGATE_ORACLE_HOME to CURRENT_HOME if it's not set...
ORACLE_HOME="${DELEGATE_ORACLE_HOME:=${CURRENT_HOME}}"
export DELEGATE_ORACLE_HOME ORACLE_HOME

# Set the directory to get wlst commands from...  
WLST_HOME="${ORACLE_HOME}/common/wlst"
export WLST_HOME

# Set the WLST extended env...
if [ -f "${SCRIPTPATH}/setWlstEnv.sh" ] ; then 
  . "${SCRIPTPATH}/setWlstEnv.sh"
fi

# Appending additional jar files to the CLASSPATH...
if [ -d "${WLST_HOME}/lib" ] ; then
    for file in "${WLST_HOME}"/lib/*.jar ; do
       CLASSPATH="${CLASSPATH}${CLASSPATHSEP}${file}"
    done
fi

# Appending additional resource bundles to the CLASSPATH...
if [ -d "${WLST_HOME}/resources" ] ; then
    for file in "${WLST_HOME}"/resources/*.jar ; do
      CLASSPATH="${CLASSPATH}${CLASSPATHSEP}${file}"
   done 
fi

export CLASSPATH

# Delegate to the COMMON_COMPONENTS_HOME script...
"${MW_HOME}/oracle_common/common/bin/wlst.sh" "$@"
exit $? 
