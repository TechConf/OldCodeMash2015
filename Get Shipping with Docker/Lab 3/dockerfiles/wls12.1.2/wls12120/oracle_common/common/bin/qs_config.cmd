@ECHO OFF
SETLOCAL

FOR /f %%i in ('cd') do set MYPWD=%%i

SET SCRIPT_PATH=%~dp0
FOR %%i IN ("%SCRIPT_PATH%") DO SET SCRIPT_PATH=%%~fsi

IF "%QS_TEMPLATES%"==""  ( 
  IF "%1"=="-help" (
    CALL "%SCRIPT_PATH%\config.cmd" %*
  ) ELSE (
    ECHO QS_TEMPLATES env variable not set.
    CALL :SET_RC 1
  )
) ELSE (
  set CONFIG_JVM_ARGS="-DuserTemplates=%QS_TEMPLATES%" 
  CALL "%SCRIPT_PATH%\config.cmd" -target=config-oneclick %*
)

SET RETURN_CODE=%ERRORLEVEL%

IF DEFINED USE_CMD_EXIT (
  EXIT %RETURN_CODE%
) ELSE (
  EXIT /B %RETURN_CODE%
)

:SET_RC
exit /b %1
