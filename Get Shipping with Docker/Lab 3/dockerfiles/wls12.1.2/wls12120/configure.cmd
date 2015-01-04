@echo off
@rem ***************************************************************************
@rem This script is used to setup certain artifacts in a zip distribution after 
@rem the extraction process. This script has to be rerun whenever the target 
@rem location is moved to another folder or machine
@rem
@rem JAVA_HOME needs to be configured prior to invoking this script
@rem MW_HOME can be set, or it will default to the directory of this script
@rem ***************************************************************************


set WLS_NAME="WebLogic Server 12g"
set WLS_VERSION="12.1.2.0"
for /f "useback tokens=*" %%n in ('%WLS_NAME%') do set WLS_NAME=%%~n
for /f "useback tokens=*" %%v in ('%WLS_VERSION%') do set WLS_VERSION=%%~v
for /f "tokens=*" %%h in ('hostname') do set MYHOST=%%h

set path2script=%~dp0
set script_dir=%path2script:~0,-1%
set winFind=%SystemRoot%\system32\find.exe
set _argAct=0
set silent_log=CON
set silent_install=
set ant_log="-logfile silent_install_ant.log" 

for %%r in (%*) do set /a _argAct+=1

IF %_argAct% NEQ 0 (
  IF "%~1" == "-silent" (
    set silent_install=true
	set silent_log=silent_install.log
) ELSE (
    echo. Usage: configure.cmd [-silent]
    echo.        No other arguments are accepted.
    echo.        Defaulting to normal usage
)
)	


IF NOT DEFINED MW_HOME (
  set NOTE=Note:      MW_HOME not supplied, default used 
  set MW_HOME=%script_dir%
)



IF NOT EXIST %MW_HOME%\ (
  echo. ERROR: You must set MW_HOME and it must point to a directory
  echo.        where an installation of WebLogic exists. Ensure you point 
  echo.        this variable to the extract location of the zip distribution.
  set _exitStat=1
  goto:finish
)

@rem Remove quotes from variables if present
set JAVA_HOME=%JAVA_HOME:"=%
set MW_HOME=%MW_HOME:"=%

@rem used by installNodeMgrSvc.cmd. Also set here before MW_HOME is shortened or manipulated to conform to 8.3 format
set BAR_WL_HOME=%MW_HOME:\=_%_wlserver
set BAR_WL_HOME=%BAR_WL_HOME::=%


@rem deal with any spaces or fancy characters in the variables
FOR %%M IN ("%MW_HOME%") DO SET MW_HOME=%%~fsM
FOR %%J IN ("%JAVA_HOME%") DO SET JAVA_HOME=%%~fsJ

IF "%silent_install%" == "" ( call:header ) ELSE ( 
@echo. %WLS_NAME% [%WLS_VERSION%] Zip Configuration > %silent_log%
@echo. MW_HOME:   %MW_HOME% >> %silent_log%
@echo. JAVA_HOME: %JAVA_HOME% >> %silent_log%
IF DEFINED NOTE (
  @echo. %NOTE% >> %silent_log%
)
)


IF NOT DEFINED JAVA_HOME (
  echo. ERROR: You must set JAVA_HOME and point it to a valid location
  echo.        where your JDK has been installed
  set _exitStat=1
  goto finish
)

IF NOT EXIST %JAVA_HOME%\bin\java.exe (
  echo. ERROR: Invalid JAVA_HOME. JAVA_HOME must point to a valid
  echo.        JDK installation
  set _exitStat=1
  goto:finish
)

setlocal enabledelayedexpansion

@rem unpack jars
@rem Find the number of files to unpack..
for /f %%i in ('"dir/b/a-d %MW_HOME%\*.jar.pack/s 2>NUL| %winFind% /v /c "::""') do set packedjarnum=%%i
IF %packedjarnum% equ 0 (
IF "%silent_install%" == "" (
@echo. Nothing to unpack
) else (
@echo. Nothing to unpack >> %silent_log%
)
) ELSE (
set unpacked=%packedjarnum%
IF "%silent_install%" == "" (
@echo %packedjarnum% jar files are being unpacked. 
@echo Please wait, title bar will show progress ...
)
for /R . %%G in (*.jar.pack) do (
   set filename=%%~nxG
   set path2jar=%%~pG
   set jarname=!filename:.pack=!
   %JAVA_HOME%\bin\unpack200.exe -r %%G  !path2jar!!jarname!
   set /a unpacked=!unpacked! - 1
   IF "%silent_install%" == "" (
   title WLS - !unpacked! more files to unpack
   )
)
)

IF "%silent_install%" == "" (
title Configuring WLS...

@echo. 
@echo. "ACLs are being setup for %MW_HOME% Please wait..."
)
echo Y|cacls %MW_HOME% /G administrators:F "creator owner":F system:F %USERDOMAIN%\%USERNAME%:F /T > NUL


endlocal

@rem Set VM_TYPE and JAVA_VENDOR if not set
IF (%VM_TYPE%)==() set VM_TYPE=HotSpot
IF (%JAVA_VENDOR%)==() set JAVA_VENDOR=Oracle

@rem Detect JVM bitness, vendor and VM_TYPE. This will be the default

set cpset=%JAVA_HOME%\lib\tools.jar;%MW_HOME%\oracle_common\modules\org.apache.ant_1.7.1\lib\ant-all.jar

%JAVA_HOME%\bin\java.exe -cp %cpset% -Dant.home=%MW_HOME%\oracle_common\modules\org.apache.ant_1.7.1 org.apache.tools.ant.Main "%ant_log%" -quiet -f %MW_HOME%\osarch.xml

@rem Above needs to happen before setWLSEnv.sh is called

call "%MW_HOME%\wlserver\server\bin\setWLSEnv.cmd" >> %silent_log%


@rem 
@rem Generate the .product.properties and the registry.xml
@rem 
%JAVA_HOME%\bin\java.exe -Dant.home=%MW_HOME%\oracle_common\modules\org.apache.ant_1.7.1 org.apache.tools.ant.Main "%ant_log%" -quiet -f %MW_HOME%\configure.xml 

IF "%silent_install%" == "" ( call:perform_optional_config )

set _exitStat=0
goto:finish

:perform_optional_config
@rem
@rem create and boot an empty domain if chosen
@rem 
@echo.
set /p ask=Do you want to configure a new domain? [Y/N]
IF /I "%ask%" == "Y" (
mkdir %MW_HOME%\user_projects\domains\mydomain
cd %MW_HOME%\user_projects\domains\mydomain
%JAVA_HOME%\bin\java.exe %JAVA_OPTIONS% -Xmx1024m -XX:MaxPermSize=256m -Dweblogic.management.GenerateDefaultConfig=true weblogic.Server
)

goto:eof

:header
@echo. **************************************************	
@echo. %WLS_NAME% [%WLS_VERSION%] Zip Configuration
@echo.
@echo. MW_HOME:   %MW_HOME%
@echo. JAVA_HOME: %JAVA_HOME%
if defined NOTE (
  @echo.
  @echo. %NOTE%
)
@echo. **************************************************
@echo. 

goto:eof

:finish
title %comspec%
exit /b %_exitStat%
