@ECHO OFF
SETLOCAL

@REM Determine the location of this script...
SET SCRIPTPATH=%~dp0
FOR %%i IN ("%SCRIPTPATH%") DO SET SCRIPTPATH=%%~fsi

@REM Set the MW_HOME relative to this script
FOR %%i IN ("%SCRIPTPATH%\..\..\..") DO SET MW_HOME=%%~fsi
set ORACLE_HOME=%MW_HOME%

IF EXIST %SCRIPTPATH%\qs_templates.cmd CALL %SCRIPTPATH%\qs_templates.cmd

IF "%QS_TEMPLATES%"==""  ( 
  IF "%1"=="-help" (
    CALL "%MW_HOME%\oracle_common\common\bin\qs_config.cmd" %*
  ) ELSE (
    ECHO QS_TEMPLATES env variable not set.
    CALL :SET_RC 1
  )
) ELSE (
  CALL "%MW_HOME%\oracle_common\common\bin\qs_config.cmd" %*
)

SET RETURN_CODE=%ERRORLEVEL%

IF DEFINED USE_CMD_EXIT (
  EXIT %RETURN_CODE%
) ELSE (
  EXIT /B %RETURN_CODE%
)

:SET_RC
EXIT /B %1
