#!/bin/sh

# WARNING: This file is created by the Configuration Wizard.
# Any changes to this script may be lost when adding extensions to this configuration.

# --- Start Functions ---

usage()
{
	echo "Usage: $1 COMPONENT_NAME {showErrorStack}"
	echo "Where:"
	echo "  COMPONENT_NAME - Required. System Component name"
	echo "  showErrorStack - Optional. Show error stack if provided."
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

if [ "$1" = "showErrorStack" ] ; then
	showErrorStack="true"
	export showErrorStack
else
	showErrorStack="false"
	export showErrorStack
fi

WL_HOME="/appl/oracle/middleware/wls/wls12120/wlserver"

DOMAIN_HOME="/appl/oracle/middleware/wls/wls12120/user_projects/domains/mydomain"

PY_LOC="${DOMAIN_HOME}/bin/stopComponent.py"

umask 027


if [ "${showErrorStack}" = "false" ] ; then
	echo "try:" >"${PY_LOC}" 
	echo "  stopComponentInternal('${componentName}', r'${DOMAIN_HOME}')" >>"${PY_LOC}" 
	echo "  exit()" >>"${PY_LOC}" 
	echo "except Exception,e:" >>"${PY_LOC}" 
	echo "  print 'Error:', sys.exc_info()[1]" >>"${PY_LOC}" 
	echo "  exit()" >>"${PY_LOC}" 
else
	echo "stopComponentInternal('${componentName}', r'${DOMAIN_HOME}')" >"${PY_LOC}" 
	echo "exit()" >>"${PY_LOC}" 
fi

echo "Stopping System Component ${componentName} ..."

if [ -f ${WL_HOME}/../oracle_common/common/bin/cam_wlst.sh ] ; then
	# Using standalone WLST if in standalone CAM environment.
	${WL_HOME}/../oracle_common/common/bin/cam_wlst.sh -i ${PY_LOC}  2>&1 
else
	# Using WLST...
	${WL_HOME}/../oracle_common/common/bin/wlst.sh -i ${PY_LOC}  2>&1 
fi

if [ -f ${PY_LOC} ] ; then
	rm -f ${PY_LOC}
fi

echo "Done"

exit

