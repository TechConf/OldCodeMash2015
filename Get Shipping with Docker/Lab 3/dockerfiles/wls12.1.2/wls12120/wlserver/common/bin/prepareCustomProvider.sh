#!/bin/sh
# utility to prepare a custom security provider MBean jar
# for use by WLST offline

# Determine the location of this script...
# Note: this will not work if the script is sourced (. ./prepareCustomProvider.sh)
SCRIPTPATH=`dirname "$0"`
SCRIPTPATH=`cd "${SCRIPTPATH}"; pwd`

# Set the MW_HOME relative to this script...
MW_HOME=`cd "${SCRIPTPATH}/../../.." ; pwd`
export MW_HOME

# Delegate to the main script...
"${MW_HOME}/oracle_common/common/bin/prepareCustomProvider.sh" "$@"
