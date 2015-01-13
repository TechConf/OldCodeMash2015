#!/bin/sh

mypwd="`pwd`"

# Determine the location of this script...
# Note: this will not work if the script is sourced (. ./qs_config.sh)
SCRIPTNAME=$0
case ${SCRIPTNAME} in
 /*)  SCRIPTPATH=`dirname "${SCRIPTNAME}"` ;;
  *)  SCRIPTPATH=`dirname "${mypwd}/${SCRIPTNAME}"` ;;
esac

# Set the MW_HOME relative to this script...
MW_HOME=`cd "${SCRIPTPATH}/../../.." ; pwd`
ORACLE_HOME=${MW_HOME}
export MW_HOME ORACLE_HOME

if [ -f ${SCRIPTPATH}/qs_templates.sh ]; then
  . "${SCRIPTPATH}/qs_templates.sh"
fi

if [ -z  "${QS_TEMPLATES}" ]; then  
  if [ "$1" != "-help" ] ; then
    echo "QS_TEMPLATES env variable not set."
    exit 1
  fi
fi  

# Delegate to the main script...
"${MW_HOME}/oracle_common/common/bin/qs_config.sh" "$@"

