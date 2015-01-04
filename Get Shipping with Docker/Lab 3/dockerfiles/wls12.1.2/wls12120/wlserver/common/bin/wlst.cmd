@ECHO OFF
SETLOCAL

@REM Determine the location of this script...
SET SCRIPTPATH=%~dp0
FOR %%i IN ("%SCRIPTPATH%") DO SET SCRIPTPATH=%%~fsi

@REM Set CURRENT_HOME...
FOR %%i IN ("%SCRIPTPATH%\..\..") DO SET CURRENT_HOME=%%~fsi

@REM Set the MW_HOME relative to the CURRENT_HOME...
FOR %%i IN ("%CURRENT_HOME%\..") DO SET MW_HOME=%%~fsi

@REM Set the DELEGATE_ORACLE_HOME to CURRENT_HOME if it's not set...
IF "%DELEGATE_ORACLE_HOME%"=="" (
  SET DELEGATE_ORACLE_HOME=%CURRENT_HOME%
)
SET ORACLE_HOME=%DELEGATE_ORACLE_HOME%

@REM Set the directory to get wlst commands from...
SET WLST_HOME=%ORACLE_HOME%\common\wlst

@REM Set the WLST extended env...
IF EXIST %SCRIPTPATH%\setWlstEnv.cmd CALL %SCRIPTPATH%\setWlstEnv.cmd

@REM Appending additional jar files to the CLASSPATH...
IF EXIST %WLST_HOME%\lib FOR %%G IN (%WLST_HOME%\lib\*.jar) DO (CALL :APPEND_CLASSPATH %%~FSG)

@REM Appending additional resource bundles to the CLASSPATH...
IF EXIST %WLST_HOME%\resources FOR %%G IN (%WLST_HOME%\resources\*.jar) DO (CALL :APPEND_CLASSPATH %%~FSG) 

@REM Delegate to the COMMON_COMPONENTS_HOME script...
SET WLST_SCRIPT=%MW_HOME%\oracle_common\common\bin\wlst.cmd
GOTO LAUNCH_WLST

:APPEND_CLASSPATH
SET CLASSPATH=%CLASSPATH%;%1
GOTO :EOF

:LAUNCH_WLST
CALL "%WLST_SCRIPT%" %*
