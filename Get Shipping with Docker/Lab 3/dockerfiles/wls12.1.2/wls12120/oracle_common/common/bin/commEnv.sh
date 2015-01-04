#*****************************************************************************
# This script is used to set up a common environment for starting WebLogic
# Server, as well as WebLogic development.
#
# It sets the following variables:
# BEA_HOME       - The home directory of all your BEA installation.
# MW_HOME        - The home directory of all your Oracle installation.
# WL_HOME        - The root directory of the BEA installation.
# COHERENCE_HOME - The root directory of the COHERENCE installation.
# ANT_HOME       - The Ant Home directory.
# ANT_CONTRIB    - The Ant contrib directory
# JAVA_HOME      - Location of the version of Java used to start WebLogic
#                  Server. See the Oracle Fusion Middleware Supported System Configurations page
#                  (http://www.oracle.com/technology/software/products/ias/files/fusion_certification.html) for an
#                  up-to-date list of supported JVMs on your platform.
# JAVA_VENDOR    - Vendor of the JVM (i.e. Oracle, HP, IBM, Sun, etc.)
# JAVA_USE_64BIT - Indicates if JVM uses 64 bit operations
# PATH           - JDK and WebLogic directories will be added to the system
#                  path.
# WEBLOGIC_CLASSPATH - Classpath required to start WebLogic Server.
# FMWCONFIG_CLASSPATH - Classpath required to start config tools such as WLST, config wizard, pack, and unpack..
# FMWLAUNCH_CLASSPATH - Additional classpath needed for WLST start script
# LD_LIBRARY_PATH, LIBPATH and SHLIB_PATH
#                - To locate native libraries.
# JAVA_VM        - The java arg specifying the VM to run.  (e.g.
#                  -server, -hotspot, etc.)
# MEM_ARGS       - The variable to override the standard memory arguments
#                  passed to java.
# CLASSPATHSEP   - CLASSPATH delimiter.
# PATHSEP        - Path delimiter.
# DERBY_HOME - Derby home directory.
# DERBY_TOOLS - Derby tools jar.
# DERBY_CLASSPATH - Classpath needed to start Derby.
# DERBY_CLIENT_CLASSPATH
#                     - Derby client classpath.
# PRODUCTION_MODE     - Indicates if the Server will be started in PRODUCTION_MODE
# PATCH_CLASSPATH     - WebLogic system classpath patch
# PATCH_LIBPATH  - Library path used for patches
# PATCH_PATH     - Path used for patches
# WEBLOGIC_EXTENSION_DIRS - Extension dirs for WebLogic classpath patch
#
# It exports the following function:
# trapSIGINT     - Get actual Derby PID when running in MKSNT environment;
#                  trap SIGINT to make sure Derby will also be stopped.
#
# resetFd        - Reset the number of open file descriptors to 1024.
#
# jDriver for Oracle users: This script assumes that native libraries required
# for jDriver for Oracle have been installed in the proper location and that
# your os specific library path variable (i.e. LD_LIBRARY_PATH/solaris,
# SHLIB_PATH/hpux, etc...) has been set appropriately.  Also note that this
# script defaults to the oci920_8 version of the shared libraries. If this is
# not the version you need, please adjust the library path variable
# accordingly.
#
#*****************************************************************************

#*****************************************************************************
# sub functions
#*****************************************************************************

# limit the number of open file descriptors
resetFd() {
  if [ ! -n "`uname -s |grep -i cygwin || uname -s |grep -i windows_nt || \
       uname -s |grep -i HP-UX`" ]
  then
    ofiles=`ulimit -S -n`
    maxfiles=`ulimit -H -n`
    if [ "$?" = "0" -a  `expr ${maxfiles} : '[0-9][0-9]*$'` -eq 0 -a `expr ${ofiles} : '[0-9][0-9]*$'` -eq 0 ]; then   
      ulimit -n 4096
    else
      if [ "$?" = "0" -a `uname -s` = "SunOS" -a `expr ${maxfiles} : '[0-9][0-9]*$'` -eq 0 ]; then
        if [ ${ofiles} -lt 65536 ]; then
          ulimit -H -n 65536
        else
          ulimit -H -n ${ofiles}
        fi
      fi
    fi
  fi
}

# Get actual Derby process when running in MKS/NT environment;
# Trap SIGINT
# input:
# DERBY_PID -- Derby server process id.
# output:
# DERBY_PID -- Actual Derby pid in MKS/NT environment.
trapSIGINT() {

  # With MKS, the pid of $! dosen't show up correctly.
  # It starts a shell process to launch whatever commands it calls.
  if [ `uname -s` = "Windows_NT" ]; then
    DERBY_PID=`ps -eo pid,ppid |
      awk -v DERBY_PID=${DERBY_PID} '$2 == DERBY_PID {print $1}'`
  fi

  # Kill Derby on interrupt from this script (^C)
  trap 'if [ "${DERBY_PID}" != "" ]; then
        kill -9 ${DERBY_PID}
        unset DERBY_PID
        fi' 2
}

#*****************************************************************************
# end of sub functions
#*****************************************************************************

if [ -z "${MW_HOME}" -a -z "${WL_HOME}" ]; then
 echo "Please set MW_HOME or WL_HOME."
 exit 1
fi

if [ ! -d "${MW_HOME}" ]; then
  MW_HOME="${WL_HOME}/.."
fi
 
if [ ! -d "${WL_HOME}" ]; then
  WL_HOME="${MW_HOME}/wlserver"
fi

# Set up BEA Home
BEA_HOME="${MW_HOME}"

# Set up COHERENCE Home
COHERENCE_HOME="${MW_HOME}/coherence"

# Set up Common Modules Directory
MODULES_DIR="${MW_HOME}/oracle_common/modules"

# Set up Common Features Directory
FEATURES_DIR="${MW_HOME}/oracle_common/modules/features"

# Set up Ant Home
ANT_HOME="${MW_HOME}/oracle_common/modules/org.apache.ant_1.7.1"

if [ -f "${WL_HOME}/modules/org.apache.ant_1.7.1/lib/ant.jar" ]; then
  ANT_HOME="${WL_HOME}/modules/org.apache.ant_1.7.1"
fi

# Set up Ant contrib
ANT_CONTRIB="${MW_HOME}/oracle_common/modules/net.sf.antcontrib_1.1.0.0_1-0b2"

#JAVA_USE_64BIT, true if JVM uses 64 bit operations
if [ ${JAVA_USE_64BIT:=@JAVA_USE_64BIT@} != true ]; then
  JAVA_USE_64BIT=false
fi

ENV_JAVA_HOME="${JAVA_HOME}"
# Reset JAVA_HOME, JAVA_VENDOR and PRODUCTION_MODE unless JAVA_HOME
# and JAVA_VENDOR are pre-defined.
if [ -z "${JAVA_HOME}" -o -z "${JAVA_VENDOR}" ]; then
  # Set up JAVA HOME
  JAVA_HOME="@JAVA_HOME@"
  # There are tests which are run without string substitution but only setting JAVA_HOME in the env.
  #This check is for that
  if [ ! -d "${JAVA_HOME}" ]; then
    JAVA_HOME="${ENV_JAVA_HOME}"
  fi 
  # Set up JAVA VENDOR, possible values are
  #Oracle, HP, IBM, Sun ...
  JAVA_VENDOR=@JAVA_VENDOR@
  # PRODUCTION_MODE, default to the development mode
  PRODUCTION_MODE=""
fi
JRE_HOME="${JAVA_HOME}"
if [ -d "${JAVA_HOME}"/jre ]; then
  JRE_HOME="${JAVA_HOME}/jre"
fi 
export JRE_HOME
if [ -z "${VM_TYPE}" ]; then
  case $JAVA_VENDOR in
   Oracle)
    if [ -d "${JRE_HOME}/bin/jrockit" ]; then
      VM_TYPE=JRockit
    else
      for jrpath in "${JRE_HOME}"/lib/*
      do
       if [ -d "${jrpath}/jrockit" ]; then
        VM_TYPE=JRockit
       fi
      done
    fi
   ;;
   Sun)
    VM_TYPE=HotSpot
   ;;
   HP)
    VM_TYPE=HotSpot
   ;;
   *)
   ;;
  esac
fi

export BEA_HOME MW_HOME WL_HOME MODULES_DIR FEATURES_DIR COHERENCE_HOME ANT_HOME ANT_CONTRIB JAVA_HOME JAVA_VENDOR PRODUCTION_MODE JAVA_USE_64BIT VM_TYPE

# Set the classpath separator
case `uname -s` in
Windows_NT*)
  CLASSPATHSEP=\;
  PATHSEP=\;
;;
CYGWIN*)
  CLASSPATHSEP=\;
;;
esac

if [ "${CLASSPATHSEP}" = "" ]; then
  CLASSPATHSEP=:
fi
if [ "${PATHSEP}" = "" ]; then
  PATHSEP=:
fi
export PATHSEP CLASSPATHSEP

VERIFY_NONE=""

# Set up JVM options base on value of JAVA_VENDOR
if [ "$PRODUCTION_MODE" = "true" ]; then
  case $JAVA_VENDOR in
  Oracle)
    if [ "${VM_TYPE}" = "JRockit" ]; then
     JAVA_VM=-jrockit
     MEM_ARGS="-Xms128m -Xmx256m"
    else
     JAVA_VM=-server
     MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"    
    fi
    VERIFY_NONE="-Xverify:none"
  ;;
  HP)
    JAVA_VM=-server
    MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"
  ;;
  IBM)
    JAVA_VM=
    MEM_ARGS="-Xms32m -Xmx200m"
  ;;
  Sun)
    JAVA_VM=-server
    MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"
    VERIFY_NONE="-Xverify:none"
  ;;
  Apple)
    JAVA_VM=-server
    MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"
  ;;
  *)
    JAVA_VM=
    MEM_ARGS="-Xms32m -Xmx200m"
  ;;
  esac
else
  case $JAVA_VENDOR in
  Oracle)
    if [ "${VM_TYPE}" = "JRockit" ]; then
     JAVA_VM=-jrockit
     MEM_ARGS="-Xms128m -Xmx256m"
    else
     JAVA_VM=-client
     MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"    
    fi
    VERIFY_NONE="-Xverify:none"
  ;;
  HP)
    JAVA_VM=-client
    MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"
  ;;
  IBM)
    JAVA_VM=
    MEM_ARGS="-Xms32m -Xmx200m"
  ;;
  Sun)
    JAVA_VM=-client
    MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"
    VERIFY_NONE="-Xverify:none"
  ;;
  Apple)
    JAVA_VM=-client
    MEM_ARGS="-Xms32m -Xmx200m -XX:MaxPermSize=128m"
  ;;
  *)
    JAVA_VM=
    MEM_ARGS="-Xms32m -Xmx200m"
  ;;
  esac
fi

JAVA_OPTIONS="${JAVA_OPTIONS} ${VERIFY_NONE} -Djava.endorsed.dirs=${JRE_HOME}/lib/endorsed${PATHSEP}${MODULES_DIR}/endorsed"

if [ "${USER_MEM_ARGS}" != "" ] ; then
  MEM_ARGS="${USER_MEM_ARGS}"
fi

case `uname -s` in
AIX)
  JAVA_OPTIONS="${JAVA_OPTIONS}  -Djavax.xml.validation.SchemaFactory:http://www.w3.org/2001/XMLSchema=org.apache.xerces.jaxp.validation.XMLSchemaFactory"
  JAVA_OPTIONS="${JAVA_OPTIONS}  -Dcom.sun.xml.namespace.QName.useCompatibleSerialVersionUID=1.0"
;;
esac

export JAVA_VM MEM_ARGS JAVA_OPTIONS

# Set-up patch related class path, extension dirs, library path and path options
if [ -f "${MW_HOME}/oracle_common/common/bin/setPatchEnv.sh" ]; then
  . "${MW_HOME}"/oracle_common/common/bin/setPatchEnv.sh
fi


# Figure out how to load java native libraries, also add -d64 for hpux and solaris 64 bit arch.
case `uname -s` in
AIX)
  if [ -n "${LIBPATH}" ]; then
    if [ "${JAVA_USE_64BIT}" = "true" ]; then
      LIBPATH=${LIBPATH}:${WL_HOME}/server/native/aix/ppc64
    else
      LIBPATH=${LIBPATH}:${WL_HOME}/server/native/aix/ppc
    fi
  else
    if [ "${JAVA_USE_64BIT}" = "true" ]; then
      LIBPATH=${WL_HOME}/server/native/aix/ppc64
    else
      LIBPATH=${WL_HOME}/server/native/aix/ppc
    fi
  fi
  LIBPATH=${PATCH_LIBPATH}:${LIBPATH}
  export LIBPATH
;;
HP-UX)
  arch=`uname -m`
  if [ "${arch}" = "ia64" ]; then
    if [ -n "${SHLIB_PATH}" ]; then
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        SHLIB_PATH=${SHLIB_PATH}:${WL_HOME}/server/native/hpux11/IPF64:${WL_HOME}/server/native/hpux11/IPF64/oci920_8
      else
        SHLIB_PATH=${SHLIB_PATH}:${WL_HOME}/server/native/hpux11/IPF32:${WL_HOME}/server/native/hpux11/IPF32/oci920_8
      fi
    else
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        SHLIB_PATH=${WL_HOME}/server/native/hpux11/IPF64:${WL_HOME}/server/native/hpux11/IPF64/oci920_8
      else
        SHLIB_PATH=${WL_HOME}/server/native/hpux11/IPF32:${WL_HOME}/server/native/hpux11/IPF32/oci920_8
      fi
    fi
  else
    if [ -n "${SHLIB_PATH}" ]; then
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        SHLIB_PATH=${SHLIB_PATH}:${WL_HOME}/server/native/hpux11/PA_RISC64:${WL_HOME}/server/native/hpux11/PA_RISC64/oci920_8
      else
        SHLIB_PATH=${SHLIB_PATH}:${WL_HOME}/server/native/hpux11/PA_RISC:${WL_HOME}/server/native/hpux11/PA_RISC/oci920_8
      fi
    else
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        SHLIB_PATH=${WL_HOME}/server/native/hpux11/PA_RISC64:${WL_HOME}/server/native/hpux11/PA_RISC64/oci920_8
      else
        SHLIB_PATH=${WL_HOME}/server/native/hpux11/PA_RISC:${WL_HOME}/server/native/hpux11/PA_RISC/oci920_8
      fi
    fi
  fi
  SHLIB_PATH=${PATCH_LIBPATH}:${SHLIB_PATH}
  export SHLIB_PATH
  if [ "${JAVA_USE_64BIT}" = "true" ] && [ "${VM_TYPE}" != "JRockit" ]
  then
     JVM_D64="-d64"
     export JVM_D64
     JAVA_VM="${JAVA_VM} ${JVM_D64}"
     export JAVA_VM
  fi
;;
LINUX|Linux)
  arch=`uname -m`
  if [ -n "${LD_LIBRARY_PATH}" ]; then
    if [ "${arch}" = "ia64" ]; then
      LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/linux/ia64:${WL_HOME}/server/native/linux/ia64/oci920_8
    else
      if [ "${arch}" = "x86_64" -a "${JAVA_USE_64BIT}" = "true" ]; then
        LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/linux/${arch}:${WL_HOME}/server/native/linux/${arch}/oci920_8
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/linux/${arch}:${WLSS_HOME}/server/native/linux/${arch}/oci920_8
        fi
      else  
        if [ "${arch}" = "s390x" ]; then 
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/linux/s390x
        else
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/linux/i686:${WL_HOME}/server/native/linux/i686/oci920_8
        fi
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/linux/i686:${WLSS_HOME}/server/native/linux/i686/oci920_8
        fi
      fi
    fi
  else
    if [ "${arch}" = "ia64" ]; then
      LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/linux/ia64:${WL_HOME}/server/native/linux/ia64/oci920_8
    else
      if [ "${arch}" = "x86_64" -a "${JAVA_USE_64BIT}" = "true" ]; then
        LD_LIBRARY_PATH=${WL_HOME}/server/native/linux/${arch}:${WL_HOME}/server/native/linux/${arch}/oci920_8
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/linux/${arch}:${WLSS_HOME}/server/native/linux/${arch}/oci920_8
        fi
      else
        if [ "${arch}" = "s390x" ]; then
          LD_LIBRARY_PATH=${WL_HOME}/server/native/linux/s390x
        else
          LD_LIBRARY_PATH=${WL_HOME}/server/native/linux/i686:${WL_HOME}/server/native/linux/i686/oci920_8
        fi
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/linux/i686:${WLSS_HOME}/server/native/linux/i686/oci920_8
        fi
      fi
    fi
  fi
  LD_LIBRARY_PATH=${PATCH_LIBPATH}:${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH
;;
OSF1)
  if [ -n "${LD_LIBRARY_PATH}" ]; then
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/tru64unix
  else
    LD_LIBRARY_PATH=${WL_HOME}/server/native/tru64unix
  fi
  LD_LIBRARY_PATH=${PATCH_LIBPATH}:${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH
;;
SunOS)
  arch=`uname -m`
  if [ -n "${LD_LIBRARY_PATH}" ]; then
    if [ "${arch}" = "i86pc" ]; then
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/solaris/x64
      else
        LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/solaris/x86
      fi
    else
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/solaris/sparc64:${WL_HOME}/server/native/solaris/sparc64/oci920_8
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/solaris/sparc64:${WLSS_HOME}/server/native/solaris/sparc64/oci920_8
        fi
      else
        LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WL_HOME}/server/native/solaris/sparc:${WL_HOME}/server/native/solaris/sparc/oci920_8
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/solaris/sparc:${WLSS_HOME}/server/native/solaris/sparc/oci920_8
        fi
      fi
    fi
  else
    if [ "${arch}" = "i86pc" ]; then
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        LD_LIBRARY_PATH=${WL_HOME}/server/native/solaris/x64
      else
        LD_LIBRARY_PATH=${WL_HOME}/server/native/solaris/x86
      fi
    else
      if [ "${JAVA_USE_64BIT}" = "true" ]; then
        LD_LIBRARY_PATH=${WL_HOME}/server/native/solaris/sparc64:${WL_HOME}/server/native/solaris/sparc64/oci920_8
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/solaris/sparc64:${WLSS_HOME}/server/native/solaris/sparc64/oci920_8
        fi
      else
        LD_LIBRARY_PATH=${WL_HOME}/server/native/solaris/sparc:${WL_HOME}/server/native/solaris/sparc/oci920_8
        if [ "$SIP_ENABLED" = "true" ]; then
          LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WLSS_HOME}/server/native/solaris/sparc:${WLSS_HOME}/server/native/solaris/sparc/oci920_8
        fi
      fi
    fi
  fi
  LD_LIBRARY_PATH=${PATCH_LIBPATH}:${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH
  if [ "${JAVA_USE_64BIT}" = "true" ] && [ "${VM_TYPE}" != "JRockit" ]
  then
    JVM_D64="-d64"
    export JVM_D64
    JAVA_VM="${JAVA_VM} ${JVM_D64}"
    export JAVA_VM
  fi
;;
Darwin)
  if [ -n "${DYLD_LIBRARY_PATH}" ]; then
    DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${WL_HOME}/server/native/macosx
  else
    DYLD_LIBRARY_PATH=${WL_HOME}/server/native/macosx
  fi
  DYLD_LIBRARY_PATH=${PATCH_LIBPATH}:${DYLD_LIBRARY_PATH}
  export DYLD_LIBRARY_PATH
;;
Windows_NT*) ;;
CYGWIN*) ;;
*)
  echo "$0: Don't know how to set the shared library path for `uname -s`.  "
esac

# setup bootstrap options
SYSTEM_LOADER=SystemClassLoader
LAUNCH_COMPLETE=weblogic.store.internal.LockManagerImpl
PCL_JAR=${WL_HOME}/server/lib/pcl2.jar

# set up profile specific classpath
PROFILE_CLASSPATH="${WL_HOME}/server/lib/weblogic_sp.jar${CLASSPATHSEP}${WL_HOME}/server/lib/weblogic.jar${CLASSPATHSEP}${WL_HOME}/server/lib/webservices.jar"
SERVER_PROFILE=`echo ${SERVER_PROFILE} | awk '{print toupper($0)}'`
if [ "${SERVER_PROFILE}" = "WEB" ]; then
    PROFILE_CLASSPATH="${WL_HOME}/server/lib/weblogic-webprofile_sp.jar${CLASSPATHSEP}${WL_HOME}/server/lib/weblogic-webprofile.jar"
fi
export PROFILE_CLASSPATH
 
# set up WebLogic Server's class path 
CAM_NODEMANAGER_JAR_PATH="${WL_HOME}/modules/features/oracle.wls.common.nodemanager_1.0.0.0.jar"

# Need to remove this logic once wls change is synched up
if [ !  -f "${CAM_NODEMANAGER_JAR_PATH}" ]; then
 CAM_NODEMANAGER_JAR_PATH="${WL_HOME}/modules/features/oracle.wls.common.cam.nodemanager_1.0.0.0.jar"
fi

export CAM_NODEMANAGER_JAR_PATH
WEBLOGIC_CLASSPATH="${JAVA_HOME}/lib/tools.jar${CLASSPATHSEP}${PROFILE_CLASSPATH}${CLASSPATHSEP}${ANT_HOME}/lib/ant-all.jar${CLASSPATHSEP}${ANT_CONTRIB}/lib/ant-contrib.jar${CLASSPATHSEP}${CAM_NODEMANAGER_JAR_PATH}"

case `uname -s` in
AIX)
WEBLOGIC_CLASSPATH="${WEBLOGIC_CLASSPATH}${CLASSPATHSEP}${MW_HOME}/oracle_common/modules/glassfish.jaxp_1.4.5.0.jar"
;;
*)
;;
esac

export WEBLOGIC_CLASSPATH
 
# set up config tools class path
FMWCONFIG_CLASSPATH="${JAVA_HOME}/lib/tools.jar${CLASSPATHSEP}${MW_HOME}/oracle_common/common/lib/config-launch.jar${CLASSPATHSEP}${PROFILE_CLASSPATH}${CLASSPATHSEP}${ANT_HOME}/lib/ant-all.jar${CLASSPATHSEP}${ANT_CONTRIB}/lib/ant-contrib.jar"
FMWLAUNCH_CLASSPATH="${MW_HOME}/oracle_common/common/lib/config-launch.jar"
if [ ! -z "${DB_DRIVER_CLASSPATH}" ]; then
  FMWLAUNCH_CLASSPATH="${FMWLAUNCH_CLASSPATH}${CLASSPATHSEP}${DB_DRIVER_CLASSPATH}"
  FMWCONFIG_CLASSPATH="${FMWCONFIG_CLASSPATH}${CLASSPATHSEP}${DB_DRIVER_CLASSPATH}" 
fi
export FMWCONFIG_CLASSPATH FMWLAUNCH_CLASSPATH

if [ "${PATCH_CLASSPATH}" != "" ] ; then
    WEBLOGIC_CLASSPATH="${PATCH_CLASSPATH}${CLASSPATHSEP}${WEBLOGIC_CLASSPATH}"
    export WEBLOGIC_CLASSPATH
    FMWCONFIG_CLASSPATH="${PATCH_CLASSPATH}${CLASSPATHSEP}${FMWCONFIG_CLASSPATH}"
    export FMWCONFIG_CLASSPATH
fi

if [ "$SIP_ENABLED" = "true" ]; then
  # set up SIP classpath
  SIP_CLASSPATH="${WLSS_HOME}/server/lib/weblogic_sip.jar"
  # add to WLS class path
  WEBLOGIC_CLASSPATH="${WEBLOGIC_CLASSPATH}${CLASSPATHSEP}${SIP_CLASSPATH}"
  export WEBLOGIC_CLASSPATH
  FMWCONFIG_CLASSPATH="${FMWCONFIG_CLASSPATH}${CLASSPATHSEP}${SIP_CLASSPATH}"
  export FMWCONFIG_CLASSPATH
fi

# DERBY configuration
DERBY_HOME="${WL_HOME}/common/derby"
DERBY_CLIENT_CLASSPATH="${DERBY_HOME}/lib/derbyclient.jar${CLASSPATHSEP}${DERBY_HOME}/lib/derby.jar"
DERBY_CLASSPATH="${CLASSPATHSEP}${DERBY_HOME}/lib/derbynet.jar${CLASSPATHSEP}${DERBY_CLIENT_CLASSPATH}"
DERBY_TOOLS="${DERBY_HOME}/lib/derbytools.jar"
DERBY_SYSTEM_HOME=${DOMAIN_HOME}/common/db
DERBY_OPTS="-Dderby.system.home=$DERBY_SYSTEM_HOME"

if [ "${DERBY_PRE_CLASSPATH}" != "" ] ; then
  DERBY_CLASSPATH="${DERBY_PRE_CLASSPATH}${CLASSPATHSEP}${DERBY_CLASSPATH}"
fi
 
if [ "${DERBY_POST_CLASSPATH}" != "" ] ; then
  DERBY_CLASSPATH="${DERBY_CLASSPATH}${CLASSPATHSEP}${DERBY_POST_CLASSPATH}"
fi

export DERBY_HOME DERBY_CLASSPATH DERBY_TOOLS DERBY_SYSTEM_HOME DERBY_OPTS 

# Set up PATH
if [ `uname -s` = "CYGWIN32/NT" ]; then
# If we are on an old version of Cygnus we need to turn <letter>:/ in the path
# to //<letter>/
  WL_HOME_CYGWIN=`echo $WL_HOME | sed 's#\([a-zA-Z]\):#//\1#g'`
  ANT_HOME_CYGWIN=`echo $ANT_HOME | sed 's#\([a-zA-Z]\):#//\1#g'`
  ANT_CONTRIB_CYGWIN=`echo $ANT_CONTRIB | sed 's#\([a-zA-Z]\):#//\1#g'`
  JAVA_HOME_CYGWIN=`echo $JAVA_HOME | sed 's#\([a-zA-Z]\):#//\1#g'`
  JRE_HOME_CYGWIN=`echo $JRE_HOME | sed 's#\([a-zA-Z]\):#//\1#g'`
  PATCH_PATH_CYGWIN=`echo $PATCH_PATH | sed 's#\([a-zA-Z]\):#//\1#g'`
  if [ -d "${JRE_HOME}/lib/ia64" ]; then
   PATH="${PATCH_PATH_CYGWIN}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/64${PATHSEP}${WL_HOME_CYGWIN}/server/bin${PATHSEP}${ANT_HOME_CYGWIN}/bin${PATHSEP}${JRE_HOME_CYGWIN}/bin${PATHSEP}${JAVA_HOME_CYGWIN}/bin${PATHSEP}${PATH}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/64/oci920_8"
  else
   if [ -d "${JRE_HOME}/lib/i386" ]; then
     PATH="${PATCH_PATH_CYGWIN}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/32${PATHSEP}${WL_HOME_CYGWIN}/server/bin${PATHSEP}${ANT_HOME_CYGWIN}/bin${PATHSEP}${JRE_HOME_CYGWIN}/bin${PATHSEP}${JAVA_HOME_CYGWIN}/bin${PATHSEP}${PATH}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/32/oci920_8"
   else
    if [ -d "${JRE_HOME}/lib/amd64" ]; then
     PATH="${PATCH_PATH_CYGWIN}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/x64${PATHSEP}${WL_HOME_CYGWIN}/server/bin${PATHSEP}${ANT_HOME_CYGWIN}/bin${PATHSEP}${JRE_HOME_CYGWIN}/bin${PATHSEP}${JAVA_HOME_CYGWIN}/bin${PATHSEP}${PATH}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/x64/oci920_8"
    fi
   fi
  fi 
else
  if [ -n "`uname -s |grep -i cygwin_`" ]; then
  # If we are on an new version of Cygnus we need to turn <letter>:/ in
  # the path to /cygdrive/<letter>/
    CYGDRIVE=`mount -ps | tail -1 | awk '{print $1}' | sed -e 's%/$%%'`
    WL_HOME_CYGWIN=`echo $WL_HOME | sed "s#\([a-zA-Z]\):#${CYGDRIVE}/\1#g"`
    ANT_HOME_CYGWIN=`echo $ANT_HOME | sed "s#\([a-zA-Z]\):#${CYGDRIVE}/\1#g"`
    PATCH_PATH_CYGWIN=`echo $PATCH_PATH | sed "s#\([a-zA-Z]\):#${CYGDRIVE}/\1#g"`
    JAVA_HOME_CYGWIN=`echo $JAVA_HOME | sed "s#\([a-zA-Z]\):#${CYGDRIVE}/\1#g"`
    JRE_HOME_CYGWIN=`echo $JRE_HOME | sed "s#\([a-zA-Z]\):#${CYGDRIVE}/\1#g"`
    if [ -d "${JRE_HOME}/lib/ia64" ]; then
     PATH="${PATCH_PATH_CYGWIN}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/64${PATHSEP}${WL_HOME_CYGWIN}/server/bin${PATHSEP}${ANT_HOME_CYGWIN}/bin${PATHSEP}${JRE_HOME_CYGWIN}/bin${PATHSEP}${JAVA_HOME_CYGWIN}/bin${PATHSEP}${PATH}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/64/oci920_8"
    else
     if [ -d "${JRE_HOME}/lib/i386" ]; then
       PATH="${PATCH_PATH_CYGWIN}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/32${PATHSEP}${WL_HOME_CYGWIN}/server/bin${PATHSEP}${ANT_HOME_CYGWIN}/bin${PATHSEP}${JRE_HOME_CYGWIN}/bin${PATHSEP}${JAVA_HOME_CYGWIN}/bin${PATHSEP}${PATH}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/32/oci920_8"
     else
      if [ -d "${JRE_HOME}/lib/amd64" ]; then
       PATH="${PATCH_PATH_CYGWIN}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/x64${PATHSEP}${WL_HOME_CYGWIN}/server/bin${PATHSEP}${ANT_HOME_CYGWIN}/bin${PATHSEP}${JRE_HOME_CYGWIN}/bin${PATHSEP}${JAVA_HOME_CYGWIN}/bin${PATHSEP}${PATH}${PATHSEP}${WL_HOME_CYGWIN}/server/native/win/x64/oci920_8"
      fi
     fi
    fi 
  else
  # set PATH for other shell environments
    PATH="${WL_HOME}/server/bin${PATHSEP}${ANT_HOME}/bin${PATHSEP}${JRE_HOME}/bin${PATHSEP}${JAVA_HOME}/bin${PATHSEP}${PATH}"
    # On Windows, include WebLogic jDriver in PATH
    if [ -n "`uname -s |grep -i windows_nt`" ]; then
     if [ -d "${JRE_HOME}/lib/ia64" ]; then
       PATH="${PATCH_PATH}${PATHSEP}${WL_HOME}/server/native/win/64${PATHSEP}${PATH}${PATHSEP}${WL_HOME}/server/native/win/64/oci920_8"
     else
      if [ -d "${JRE_HOME}/lib/i386" ]; then
        PATH="${PATCH_PATH}${PATHSEP}${WL_HOME}/server/native/win/32${PATHSEP}${PATH}${PATHSEP}${WL_HOME}/server/native/win/32/oci920_8"
      else
       if [ -d "${JRE_HOME}/lib/amd64" ]; then
         PATH="${PATCH_PATH}${PATHSEP}${WL_HOME}/server/native/win/x64${PATHSEP}${PATH}${PATHSEP}${WL_HOME}/server/native/win/x64/oci920_8"
       fi
      fi
     fi 
    fi
  fi
fi
export PATH

resetFd

