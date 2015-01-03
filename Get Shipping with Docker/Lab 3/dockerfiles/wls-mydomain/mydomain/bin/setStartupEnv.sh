#!/bin/sh

# WARNING: This file is created by the Configuration Wizard.
# Any changes to this script may be lost when adding extensions to this configuration.

# *************************************************************************
#   Server scoped startup configuration.
# *************************************************************************

# Associate all admin-server server-groups to AdminServerStartupGroup

if [ "${STARTUP_GROUP}" != "" ] ; then
	if [ "${STARTUP_GROUP}" = "BASE-WLS-ADMIN-SVR" ] ; then
		STARTUP_GROUP="AdminServerStartupGroup"
		export STARTUP_GROUP
	fi
fi

# Associate server with a startup group

if [ "${STARTUP_GROUP}" = "" ] ; then
	if [ "${SERVER_NAME}" = "myserver" ] ; then
		STARTUP_GROUP="AdminServerStartupGroup"
		export STARTUP_GROUP
	fi
fi

# Startup parameters for STARTUP_GROUP AdminServerStartupGroup

if [ "${STARTUP_GROUP}" = "AdminServerStartupGroup" ] ; then
	# POST_CLASSPATH.
	if [ "${POST_CLASSPATH}" != "" ] ; then
		POST_CLASSPATH="${POST_CLASSPATH}${CLASSPATHSEP}${MW_HOME}/oracle_common/modules/com.oracle.cie.config-wls-online_8.0.0.0.jar"
		export POST_CLASSPATH
	else
		POST_CLASSPATH="${MW_HOME}/oracle_common/modules/com.oracle.cie.config-wls-online_8.0.0.0.jar"
		export POST_CLASSPATH
	fi
fi

