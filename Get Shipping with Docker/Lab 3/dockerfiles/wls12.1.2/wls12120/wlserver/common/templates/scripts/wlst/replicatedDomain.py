#=======================================================================================
# This is an example of a simple WLST offline configuration script. The script creates
# a replicated WebLogic SIP Server domain using the Replicated Domain
# template. The script demonstrates how to open a domain template, create and edit
# configuration objects, and write the domain configuration information to the
# specified directory.
#
# The sample consists of an admin server, two engine servers, and two replica servers.
#
# Please note that some of the values used in this script are subject to change based on
# your WebLogic installation and the template you are using.
#
# Usage:
#      java weblogic.WLST <WLST_script>
#
# Where:
#      <WLST_script> specifies the full path to the WLST script.
#=======================================================================================

#=======================================================================================
# Open a domain template.
#=======================================================================================

readTemplate("$MW_HOME/wlserver/common/templates/wls/wls.jar")
addTemplate("$MW_HOME/wlserver/common/templates/wls/replicateddomain.jar")

#=======================================================================================
# Configure the Administration Server and SSL port.
#
# To enable access by both local and remote processes, you should not set the
# listen address for the server instance (that is, it should be left blank or not set).
# In this case, the server instance will determine the address of the machine and
# listen on it.
#=======================================================================================

cd('Servers/AdminServer')
set('ListenAddress','')
set('ListenPort', 7001)

create('AdminServer','SSL')
cd('SSL/AdminServer')
set('Enabled', 'True')
set('ListenPort', 7002)

#=======================================================================================
# Define the user password for weblogic.
#=======================================================================================

cd('/')
cd('Security/base_domain/User/weblogic')
# Please set password here before using this script, e.g. cmo.setPassword('value')

#=======================================================================================
# Write the domain and close the domain template.
#=======================================================================================

setOption('OverwriteDomain', 'true')
writeDomain('$MW_HOME/user_projects/domains/replicatedDomain')
closeTemplate()

#=======================================================================================
# Exit WLST.
#=======================================================================================

exit()
