@rem *************************************************************************
@rem This script is used to initialize common environment to start WebLogic
@rem Server, as well as WebLogic development.
@rem
@rem It sets the following variables:
@rem
@rem BEA_HOME   - The home directory of all your BEA installation.
@rem MW_HOME    - The home directory of all your Oracle installation.
@rem WL_HOME    - The root directory of your WebLogic installation.
@rem COHERENCE_HOME    - The root directory of your Coherence installation.
@rem ANT_HOME   - The Ant Home directory.
@rem ANT_CONTRIB
@rem            - The Ant contrib directory
@rem JAVA_HOME  - Location of the version of Java used to start WebLogic
@rem              Server. See the Oracle Fusion Middleware Supported System Configurations page at
@rem              (http://www.oracle.com/technology/software/products/ias/files/fusion_certification.html) for an
@rem              up-to-date list of supported JVMs on your platform.
@rem JAVA_VENDOR
@rem            - Vendor of the JVM (i.e. BEA, HP, IBM, Sun, etc.)
@rem JAVA_USE_64BIT
@rem            - Indicates if JVM uses 64 bit operations
@rem PATH       - JDK and WebLogic directories are added to the system path.
@rem WEBLOGIC_CLASSPATH
@rem            - Classpath required to start WebLogic server.
@rem FMWCONFIG_CLASSPATH
@rem            - Classpath required to start config tools such as config wizard, pack, and unpack..
@rem FMWLAUNCH_CLASSPATH
@rem            - Additional classpath needed for WLST start script
@rem JAVA_VM    - The java arg specifying the JVM to run.  (i.e.
@rem              -server, -hotspot, -jrocket etc.)
@rem MEM_ARGS   - The variable to override the standard memory arguments
@rem              passed to java
@rem
@rem DERBY_HOME
@rem            - Derby home directory.
@rem DERBY_CLASSPATH
@rem            - Classpath needed to start Derby.
@rem DERBY_TOOLS
@rem            - Derby tools jar file.
@rem PRODUCTION_MODE
@rem            - Indicates if WebLogic Server will be started in Production
@rem              mode.
@rem PATCH_CLASSPATH
@rem            - WebLogic Patch system classpath
@rem PATCH_LIBPATH  
@rem            - Library path used for patches
@rem PATCH_PATH     
@rem            - Path used for patches
@rem WEBLOGIC_EXTENSION_DIRS
@rem            - Extension dirs for WebLogic classpath patch
@rem
@rem *************************************************************************

IF NOT DEFINED MW_HOME (
 IF NOT DEFINED WL_HOME (
  echo Please set MW_HOME or WL_HOME 
  IF DEFINED USE_CMD_EXIT (
   EXIT 1
  ) ELSE (
   EXIT /B 1
  )
 )
)

IF NOT DEFINED MW_HOME (
 set MW_HOME=%WL_HOME%\..
) ELSE (
 IF NOT EXIST "%MW_HOME%" set MW_HOME=%WL_HOME%\..
)
FOR %%i IN ("%MW_HOME%") DO SET MW_HOME=%%~fsi

IF NOT DEFINED WL_HOME set WL_HOME=%MW_HOME%\wlserver
FOR %%i IN ("%WL_HOME%") DO SET WL_HOME=%%~fsi

@rem Set Middleware Home
set BEA_HOME=%MW_HOME%

@rem Set Coherence Home
set COHERENCE_HOME=%MW_HOME%\coherence

@rem Set Common Modules Directory
set MODULES_DIR=%MW_HOME%\oracle_common\modules

@rem Set Common Features Directory
set FEATURES_DIR=%MW_HOME%\oracle_common\modules\features

@rem Set Ant Home
set ANT_HOME=%MW_HOME%\oracle_common\modules\org.apache.ant_1.7.1
if exist %WL_HOME%\modules\org.apache.ant_1.7.1\lib\ant.jar (
  set ANT_HOME=%WL_HOME%\modules\org.apache.ant_1.7.1
) 

@rem Set Ant Contrib
set ANT_CONTRIB=%MW_HOME%\oracle_common\modules\net.sf.antcontrib_1.1.0.0_1-0b2

@rem shorten CLASSPATH and PATH
if exist "%MW_HOME%\oracle_common\common\bin\shortenPaths.cmd" call "%MW_HOME%\oracle_common\common\bin\shortenPaths.cmd"

@rem Reset JAVA_HOME, JAVA_VENDOR and PRODUCTION_MODE unless JAVA_HOME and
@rem JAVA_VENDOR are defined already.
if   DEFINED JAVA_HOME   if  DEFINED JAVA_VENDOR goto noReset

@rem Reset JAVA Home
if NOT DEFINED JAVA_HOME set  JAVA_HOME=@JAVA_HOME@
FOR %%i IN ("%JAVA_HOME%") DO SET JAVA_HOME=%%~fsi

@rem JAVA VENDOR, possible values are:
@rem Oracle, HP, IBM, Sun, etc.
if NOT DEFINED JAVA_VENDOR set  JAVA_VENDOR=@JAVA_VENDOR@

@rem PRODUCTION_MODE, default to the development mode
set  PRODUCTION_MODE=

:noReset
set JRE_HOME=%JAVA_HOME%
IF EXIST %JAVA_HOME%\jre set JRE_HOME=%JAVA_HOME%\jre
@rem JAVA_USE_64BIT, true if JVM uses 64 bit operations 
set JAVA_USE_64BIT=false
IF EXIST %JRE_HOME%\lib\ia64 ( set JAVA_USE_64BIT=true
) ELSE (
 IF EXIST %JRE_HOME%\lib\amd64 set JAVA_USE_64BIT=true
)

@rem set up JVM options
if "%JAVA_VENDOR%" == "Oracle" goto oracle
if "%JAVA_VENDOR%" == "Sun" goto sun

goto continue

:oracle
if "%VM_TYPE%" == "HotSpot" goto sun
set VM_TYPE=HotSpot
if exist %JRE_HOME%/bin/jrockit (
  set VM_TYPE=JRockit
) else (
  for /d %%I in (%JRE_HOME%\lib\*) do if exist %%I\jrockit set VM_TYPE=JRockit
)    

if NOT "%VM_TYPE%" == "JRockit" goto sun
if "%PRODUCTION_MODE%" == "true" goto oracle_prod_mode
set JAVA_VM=-jrockit
set MEM_ARGS=-Xms128m -Xmx256m
set JAVA_OPTIONS=%JAVA_OPTIONS% -Xverify:none -Djava.endorsed.dirs=%JRE_HOME%\lib\endorsed;%MODULES_DIR%\endorsed
goto continue
:oracle_prod_mode
set JAVA_VM=-jrockit
set MEM_ARGS=-Xms128m -Xmx256m
set JAVA_OPTIONS=%JAVA_OPTIONS% -Djava.endorsed.dirs=%JRE_HOME%\lib\endorsed;%MODULES_DIR%\endorsed
goto continue


:sun
set VM_TYPE=HotSpot
if "%PRODUCTION_MODE%" == "true" goto sun_prod_mode
set JAVA_VM=-client
set MEM_ARGS=-Xms32m -Xmx200m -XX:MaxPermSize=128m -XX:+UseSpinning
set JAVA_OPTIONS=%JAVA_OPTIONS% -Xverify:none -Djava.endorsed.dirs=%JRE_HOME%\lib\endorsed;%MODULES_DIR%\endorsed
goto continue
:sun_prod_mode
set JAVA_VM=-server
set MEM_ARGS=-Xms32m -Xmx200m -XX:MaxPermSize=128m -XX:+UseSpinning
set JAVA_OPTIONS=%JAVA_OPTIONS% -Djava.endorsed.dirs=%JRE_HOME%\lib\endorsed;%MODULES_DIR%\endorsed
goto continue

:continue


if DEFINED USER_MEM_ARGS (
   set MEM_ARGS=%USER_MEM_ARGS%
)


@rem setup patch related class path, library path, path and extension dirs options
if exist "%MW_HOME%\oracle_common\common\bin\setPatchEnv.cmd" call "%MW_HOME%\oracle_common\common\bin\setPatchEnv.cmd"

@rem setup bootstrap options
set SYSTEM_LOADER=SystemClassLoader
set LAUNCH_COMPLETE=weblogic.store.internal.LockManagerImpl
set PCL_JAR=%WL_HOME%\server\lib\pcl2.jar

@rem setup profile specific server classpath

set PROFILE_CLASSPATH=%WL_HOME%\server\lib\weblogic_sp.jar;%WL_HOME%\server\lib\weblogic.jar;%WL_HOME%\server\lib\webservices.jar
if /I "%SERVER_PROFILE%" == "WEB" (
    set PROFILE_CLASSPATH=%WL_HOME%\server\lib\weblogic-webprofile_sp.jar;%WL_HOME%\server\lib\weblogic-webprofile.jar
)

@rem set up WebLogic Server's class path and config tools classpath
set CAM_NODEMANAGER_JAR_PATH=%WL_HOME%\modules\features\oracle.wls.common.nodemanager_1.0.0.0.jar

set CAM_NODEMANAGER_JAR_PATH_OLD=%WL_HOME%\modules\features\oracle.wls.common.cam.nodemanager_1.0.0.0.jar
IF EXIST %CAM_NODEMANAGER_JAR_PATH_OLD%  set CAM_NODEMANAGER_JAR_PATH=%CAM_NODEMANAGER_JAR_PATH_OLD%

set WEBLOGIC_CLASSPATH=%JAVA_HOME%\lib\tools.jar;%PROFILE_CLASSPATH%;%ANT_HOME%/lib/ant-all.jar;%ANT_CONTRIB%/lib/ant-contrib.jar;%CAM_NODEMANAGER_JAR_PATH%

set FMWCONFIG_CLASSPATH=%JAVA_HOME%\lib\tools.jar;%MW_HOME%\oracle_common\common\lib\config-launch.jar;%PROFILE_CLASSPATH%;%ANT_HOME%/lib/ant-all.jar;%ANT_CONTRIB%/lib/ant-contrib.jar
@rem set up launch classpath for use by WLST   
set FMWLAUNCH_CLASSPATH=%MW_HOME%\oracle_common\common\lib\config-launch.jar

if DEFINED DB_DRIVER_CLASSPATH (
  set FMWCONFIG_CLASSPATH=%FMWCONFIG_CLASSPATH%;%DB_DRIVER_CLASSPATH%
  set FMWLAUNCH_CLASSPATH=%FMWLAUNCH_CLASSPATH%;%DB_DRIVER_CLASSPATH%  
)


if NOT "%PATCH_CLASSPATH%"=="" (
  set WEBLOGIC_CLASSPATH=%PATCH_CLASSPATH%;%WEBLOGIC_CLASSPATH%
  set FMWCONFIG_CLASSPATH=%PATCH_CLASSPATH%;%FMWCONFIG_CLASSPATH%
)

if /I "%SIP_ENABLED%"=="true" goto set_sip_classpath
goto no_sip

:set_sip_classpath
@rem set up SIP classpath
set SIP_CLASSPATH=%WLSS_HOME%\server\lib\weblogic_sip.jar
@rem add to WLS classpath
set WEBLOGIC_CLASSPATH=%WEBLOGIC_CLASSPATH%;%SIP_CLASSPATH%
set FMWCONFIG_CLASSPATH=%FMWCONFIG_CLASSPATH%;%SIP_CLASSPATH%
:no_sip

@rem add jvm and WebLogic directory in path
IF NOT EXIST "%JRE_HOME%" goto cont_path

set WL_USE_X86DLL=false
set WL_USE_IA64DLL=false
set WL_USE_AMD64DLL=false
IF EXIST %JRE_HOME%\lib\i386  goto i386_path
IF EXIST %JRE_HOME%\lib\ia64  goto ia64_path
IF EXIST %JRE_HOME%\lib\amd64 goto amd64_path
goto cont_path

:i386_path
set PATH=%PATCH_PATH%;%WL_HOME%\server\native\win\32;%WL_HOME%\server\bin;%ANT_HOME%\bin;%JRE_HOME%\bin;%JAVA_HOME%\bin;%PATH%;%WL_HOME%\server\native\win\32\oci920_8
set WL_USE_X86DLL=true
goto cont_path

:ia64_path
set PATH=%PATCH_PATH%;%WL_HOME%\server\native\win\64;%WL_HOME%\server\bin;%ANT_HOME%\bin;%JRE_HOME%\bin;%JAVA_HOME%\bin;%PATH%;%WL_HOME%\server\native\win\64\oci920_8
set WL_USE_IA64DLL=true
goto cont_path

:amd64_path
set PATH=%PATCH_PATH%;%WL_HOME%\server\native\win\x64;%WL_HOME%\server\bin;%ANT_HOME%\bin;%JRE_HOME%\bin;%JAVA_HOME%\bin;%PATH%;%WL_HOME%\server\native\win\x64\oci920_8
set WL_USE_AMD64DLL=true

:cont_path

@rem set up DERBY configuration
set DERBY_HOME=%WL_HOME%\common\derby
set DERBY_CLIENT_CLASSPATH=%DERBY_HOME%\lib\derbyclient.jar;%DERBY_HOME%\lib\derby.jar
set DERBY_CLASSPATH=%DERBY_HOME%\lib\derbynet.jar;%DERBY_CLIENT_CLASSPATH%
set DERBY_TOOLS=%DERBY_HOME%\lib\derbytools.jar
set DERBY_SYSTEM_HOME=%DOMAIN_HOME%\common\db
set DERBY_OPTS="-Dderby.system.home=%DERBY_SYSTEM_HOME%"

IF NOT "%DERBY_PRE_CLASSPATH%"=="" (
  set DERBY_CLASSPATH=%DERBY_PRE_CLASSPATH%;%DERBY_CLASSPATH%
)
IF NOT "%DERBY_POST_CLASSPATH%"=="" (
  set DERBY_CLASSPATH=%DERBY_CLASSPATH%;%DERBY_POST_CLASSPATH%
)

:end
