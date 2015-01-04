#!/bin/sh

# WARNING: This file is created by the Configuration Wizard.
# Any changes to this script may be lost when adding extensions to this configuration.

# --- Start Functions ---

usage()
{
	echo "Usage: $1 COMPONENT_NAME {storeUserConfig} {showErrorStack}"
	echo "Where:"
	echo "  COMPONENT_NAME  - Required. System Component name"
	echo "  storeUserConfig - Optional. If provided, save the user config into a key file if the file does not exist. "
	echo "  showErrorStack  - Optional. Show error stack if provided."
}

# --- End Functions ---

if [ "$1" = "" ] ; then
	usage $0
	exit
else
	componentName="$1"
	export componentName
	shift
fi

if [ "$1" = "storeUserConfig" ] ; then
	storeUserConfig="true"
	export storeUserConfig
	shift
else
	storeUserConfig="false"
	export storeUserConfig
fi

if [ "$1" = "showErrorStack" ] ; then
	showErrorStack="true"
	export showErrorStack
else
	showErrorStack="false"
	export showErrorStack
fi

WL_HOME="/appl/oracle/middleware/wls/wls12120/wlserver"

DOMAIN_HOME="/appl/oracle/middleware/wls/wls12120/user_projects/domains/mydomain"

PY_LOC="${DOMAIN_HOME}/bin/startComponent.py"

umask 027


if [ "${showErrorStack}" = "false" ] ; then
	echo "try:" >"${PY_LOC}" 
	echo "  startComponentInternal('${componentName}', r'${DOMAIN_HOME}', '${storeUserConfig}')" >>"${PY_LOC}" 
	echo "  exit()" >>"${PY_LOC}" 
	echo "except Exception,e:" >>"${PY_LOC}" 
	echo "  print 'Error:', sys.exc_info()[1]" >>"${PY_LOC}" 
	echo "  exit()" >>"${PY_LOC}" 
else
	echo "startComponentInternal('${componentName}', r'${DOMAIN_HOME}', '${storeUserConfig}')" >"${PY_LOC}" 
	echo "exit()" >>"${PY_LOC}" 
fi

echo "Starting system Component ${componentName} ..."

if [ -f ${WL_HOME}/../oracle_common/common/bin/cam_wlst.sh ] ; then
	# Start standalone WLST if in standalone CAM environment.
	${WL_HOME}/../oracle_common/common/bin/cam_wlst.sh -i ${PY_LOC}  2>&1 
else
	# Start WLST.
	${WL_HOME}/../oracle_common/common/bin/wlst.sh -i ${PY_LOC}  2>&1 
fi

if [ -f ${PY_LOC} ] ; then
	rm -f ${PY_LOC}
fi

echo "Done"

exit

