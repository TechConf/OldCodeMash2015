@echo off
@rem *************************************************************************
@rem This script is used to install NodeManager as a Windows Service.
@rem
@rem This script sets the following variables before installing
@rem WebLogic Server as a Windows Service:
@rem
@rem WL_HOME    - The root directory of your WebLogic installation.
@rem NODEMGR_HOME - The home directory for this NodeManager instance.
@rem PATH       - Adds the JDK and WebLogic directories to the system path.  
@rem CLASSPATH  - Adds the JDK and WebLogic jars to the classpath.  
@rem *************************************************************************

SETLOCAL

set WL_HOME=%MW_HOME%\wlserver
call "%WL_HOME%\..\oracle_common\common\bin\commEnv.cmd"

@rem Set user-defined variables
if "%NODEMGR_HOME%"=="" (
  set NODEMGR_HOME=%WL_HOME%\..\oracle_common\common\nodemanager
) else (
  echo NODEMGR_HOME is already set to "%NODEMGR_HOME%" 
)


@rem If NODEMGR_HOME does not exist, create it
:checkNodeManagerHome
if exist %NODEMGR_HOME% goto checkJava
echo.
echo NODEMGR_HOME %NODEMGR_HOME% does not exist, creating it..
mkdir %NODEMGR_HOME%

@rem Check that java is where we expect it to be
:checkJava
if exist "%JAVA_HOME%\bin\java.exe" goto runNodeManager
echo.
echo The JDK wasn't found in directory %JAVA_HOME%.
echo Please edit this script so that the JAVA_HOME
echo variable points to the location of your JDK.
goto finish

:runNodeManager
@echo on
set CLASSPATH=.;%WEBLOGIC_CLASSPATH%
@rem the service loads dll file, so the JAVA_VM *must* be correct
if exist %JRE_HOME%\bin\client (
set JAVA_VM=-client
) else if exist %JRE_HOME%\bin\server (
set JAVA_VM=-server
) else if exist %JRE_HOME%\bin\jrockit (
set JAVA_VM=-jrockit
)

set MEM_ARGS=-Xms32m -Xmx200m
set BAR_WL_HOME=%WL_HOME:\=_%
set BAR_WL_HOME=%BAR_WL_HOME::=%
if "%NODEMGR_HOST%"=="" (
  set NODEMGR_HOST=localhost
) else (
  echo NODEMGR_HOST is already set to %NODEMGR_HOST% 
)

if "%PROD_NAME%"=="" (
  set PROD_NAME=@PROD_NAME
) else (
  echo PROD_NAME is already set to %PROD_NAME% 
)
if "%PROD_NAME%"=="@PROD_NAME" (
  set PROD_NAME="OracleWebLogic"
)
rem *** Set Command Line for service to execute within created JVM

set CMDLINE=%JAVA_VM% %MEM_ARGS% %JAVA_OPTIONS% -classpath \"%CLASSPATH%\" -Djava.security.policy=\"%WL_HOME%\server\lib\weblogic.policy\" -Dweblogic.nodemanager.javaHome=\"%JAVA_HOME%\"  

if NOT "%NODEMGR_HOST%" == "" set CMDLINE=%CMDLINE% -DListenAddress=\"%NODEMGR_HOST%\"

if NOT "%NODEMGR_PORT%" == "" set CMDLINE=%CMDLINE% -DListenPort=\"%NODEMGR_PORT%\"

if not "%MW_HOME%" == "" set CMDLINE=%CMDLINE% -Dbea.home=%MW_HOME%

if not "%COHERENCE_HOME%" == "" set CMDLINE=%CMDLINE% -Dcoherence.home=%COHERENCE_HOME%

set CMDLINE=%CMDLINE% weblogic.NodeManager

:install
rem *** Set up extrapath for win32 and win64 platform separately
set WLSVC_EXE_TO_USE=wlsvcx64
if "%WL_USE_X86DLL%" == "true" (
 set EXTRAPATH=%WL_HOME%\server\native\win\32;%WL_HOME%\server\bin;%JAVA_HOME%\jre\bin;%JAVA_HOME%\bin;%WL_HOME%\server\native\win\32\oci920_8
 set WLSVC_EXE_TO_USE=wlsvc
)

if "%WL_USE_IA64DLL%" == "true" (
 set EXTRAPATH=%WL_HOME%\server\native\win\64;%WL_HOME%\server\bin;%JAVA_HOME%\jre\bin;%JAVA_HOME%\bin;%WL_HOME%\server\native\win\64\oci920_8
 set WLSVC_EXE_TO_USE=wlsvc64
)

if "%WL_USE_AMD64DLL%" == "true" (
 set EXTRAPATH=%WL_HOME%\server\native\win\x64;%WL_HOME%\server\bin;%JAVA_HOME%\jre\bin;%JAVA_HOME%\bin;%WL_HOME%\server\native\win\x64\oci920_8
 set WLSVC_EXE_TO_USE=wlsvcx64
)

rem *** Install the service
"%WL_HOME%\server\bin\%WLSVC_EXE_TO_USE%" -install -svcname:"%PROD_NAME% NodeManager (%BAR_WL_HOME%)" -javahome:"%JAVA_HOME%" -execdir:"%NODEMGR_HOME%" -extrapath:"%EXTRAPATH%" -cmdline:"%CMDLINE%"

:finish

ENDLOCAL

