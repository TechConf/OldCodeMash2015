#!/bin/bash

# ****************************************************************************
# This script is used to setup certain artifacts in a zip distribution after 
# the extraction process. This script has to be rerun whenever the target 
# location is moved to another folder or machine
#
# JAVA_HOME needs to be configured prior to invoking this script
# MW_HOME can be set, or it will default to the directory of this script
# ****************************************************************************

# define some constants
filler="                                                                                               "
WLS_NAME="WebLogic Server 12g"
WLS_VERSION="12.1.2.0"
MYHOST=`hostname`
myOS=`uname -s`

# Output the header
header() {
  echo "**************************************************"	
  echo "$WLS_NAME ($WLS_VERSION) Zip Configuration"
  echo ""
  echo "MW_HOME:   $MW_HOME"
  echo "JAVA_HOME: $JAVA_HOME"
  if [ "x" != "x${NOTE}" ]; then 
    echo ""
    echo "$NOTE"
  fi 
  echo "**************************************************"	
  echo ""  
}

# Generate demo key
generatekey() {
  $JAVA_HOME/bin/java utils.CertGen -keyfile $WL_HOME/server/lib/privatekeyfile -keyfilepass DemoIdentityPassPhrase -certfile $WL_HOME/server/lib/certfile -cn $MYHOST
  $JAVA_HOME/bin/java utils.der2pem $WL_HOME/server/lib/CertGenCA.der
  cat $WL_HOME/server/lib/certfile.pem $WL_HOME/server/lib/CertGenCA.pem > $WL_HOME/server/lib/newcerts.pem
  $JAVA_HOME/bin/java utils.ImportPrivateKey -keystore $WL_HOME/server/lib/DemoIdentity.jks -storepass DemoIdentityKeyStorePassPhrase \
    -keyfile $WL_HOME/server/lib/privatekeyfile.pem -keyfilepass DemoIdentityPassPhrase -certfile $WL_HOME/server/lib/newcerts.pem -alias DemoIdentity
}

# Optional config step
create_user_domain() {
  MYOS=`uname -s`
  echo -n "$1 [$2/$3]? "
  read response
  finish=-1
  while [ "$finish" == '-1' ]
  do
    finish="1"
    if [ "response" == '' ];
    then
       response=""
    else
       case $response in
           y | Y | yes |YES | Yes ) response="y";;
           n | N | no | NO | No )   response="n";;
           *) finish="-1";
              echo -n 'Invalid response -- please reenter:';
              read response;;
       esac
    fi
  done
  if [ "$response" == "y" ];
  then
     mkdir -p $MW_HOME/user_projects/domains/mydomain
     cd $MW_HOME/user_projects/domains/mydomain
     $JAVA_HOME/bin/java -Djava.endorsed.dirs="${MW_HOME}/oracle_common/modules/endorsed" \
          -Xmx1024m -XX:MaxPermSize=256m -Dweblogic.management.GenerateDefaultConfig=true weblogic.Server
  fi
}  

SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE}) && pwd)"

case $myOS in
CYGWIN*) export OS="Cygwin"
         CLASSPATHSEP=\;
;;
Windows_NT*) export OS="Windows"
		     CLASSPATHSEP=\;
;;
*)           CLASSPATHSEP=:
;;
esac


if [ $# -ne 0 ]; then
  if [ "$1" != "-silent" ]; then
    echo "Usage: ./configure.sh [-silent]"
    echo "       No other arguments are accepted."
    echo "       Defaulting to normal usage"
  else
    silent_install=true
    silent_log=silent_install.log
    ant_log="-logfile silent_install_ant.log"
  fi
fi

if [ -z "$MW_HOME" ]; then
     MW_HOME=${SCRIPT_DIR}
     export MW_HOME
     NOTE="Note:      MW_HOME not supplied, default used" 
fi

if [ "$OS" == "Cygwin" ]
then
  export CYGWIN=nodosfilewarning
  export JAVA_HOME=`cygpath -m $JAVA_HOME`
  export MW_HOME=`cygpath -m $MW_HOME`
fi


# Let users know the MW_HOME and JAVA_HOME that were set
if [ -z "$silent_install" ]; then
header
else
header > ${silent_log} 2>&1
fi

# Users must set $MW_HOME variable
if [ -z "$MW_HOME" ] || [ ! -d "$MW_HOME" ]; then
  echo "ERROR: You must set MW_HOME and it must point to a directory"
  echo "       where an installation of WebLogic exists. Ensure you point"
  echo "       this variable to the extract location of the zip distribution."
  exit 1; 
fi

# Users must set $JAVA_HOME variable
if [  -z "${JAVA_HOME}" ] || [ ! -d "${JAVA_HOME}/bin" ]; then
  echo "ERROR: You must set JAVA_HOME and point it to a valid location"
  echo "       where your JDK has been installed"
  exit 1;
fi

# Unpack jars
tpack=`find ${MW_HOME} -name \*.jar.pack`;
tpacknum=`echo $tpack | tr ' ' '\n' | wc -l`
 if [ ${tpacknum} -eq 0 ]
 then
  if [ -z ${silent_install} ]; then
   echo "Note: Nothing to unpack"
  fi
 else
   if [ -z ${silent_install} ]; then
      echo "Please wait while $tpacknum jars are unpacked ..."
   else
      echo  "Unpacking $tpacknum jars..." >> ${silent_log}
   fi
   for packedjar in `echo $tpack`
   do
     tpacknum=`expr $tpacknum - 1`
     jarname=`basename $packedjar | sed 's/\.pack//g'`
     formattedname=$(printf "%-80s" $jarname)
     tpackstr=$(printf "%3d" $tpacknum)
     if [ -z ${silent_install} ]; then
       printf "\rUnpacking $formattedname $tpackstr to go"
     else
       echo ..... ${jarname} >> ${silent_log}
     fi
     path2jar=`dirname $packedjar`
     "${JAVA_HOME}/bin/unpack200" -r ${packedjar} ${path2jar}/${jarname}
   done
   if [ -z ${silent_install} ]; then   
     printf "\r...Unpacking done                       \n\n"
   else
     echo "Done." >> ${silent_log}
   fi
 fi
 
# Detect JVM bitness, vendor and VM_TYPE. This will be the default

cpset=${JAVA_HOME}/lib/tools.jar${CLASSPATHSEP}${MW_HOME}/oracle_common/modules/org.apache.ant_1.7.1/lib/ant-all.jar

"${JAVA_HOME}/bin/java" -cp ${cpset} -Dant.home=${MW_HOME}/oracle_common/modules/org.apache.ant_1.7.1 \
  org.apache.tools.ant.Main ${ant_log} -quiet -f ${MW_HOME}/osarch.xml

if [ -f wlsenv.properties ]
then
. wlsenv.properties
export SUN_ARCH_DATA_MODEL JAVA_USE_64BIT
export USER_MEM_ARGS="-Xms160m -Xmx300m -XX:MaxPermSize=256m -XX:MaxNewSize=65m -XX:NewSize=65m"
mv wlsenv.properties wlsenv.properties.bak
fi

# Above needs to happen before setWLSEnv.sh is called

# Setup the WLS environment
if [ -z ${silent_install} ]; then
. ${MW_HOME}/wlserver/server/bin/setWLSEnv.sh
else
. ${MW_HOME}/wlserver/server/bin/setWLSEnv.sh >> ${silent_log} 2>&1
fi
# Generate .product.properties required for configuration
# provisioning
if [ -z ${silent_install} ]; then
echo Configuring WLS...
fi

"${JAVA_HOME}/bin/java" -Dant.home=${MW_HOME}/oracle_common/modules/org.apache.ant_1.7.1 \
  org.apache.tools.ant.Main ${ant_log} -quiet -f ${MW_HOME}/configure.xml

# Generate new certificate
if [ -z ${silent_install} ]; then
echo " "
create_user_domain "Do you want to configure a new domain? " "y" "n"
fi  
