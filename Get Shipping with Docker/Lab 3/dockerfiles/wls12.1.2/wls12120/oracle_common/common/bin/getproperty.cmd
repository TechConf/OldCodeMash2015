@ECHO OFF

IF "%1"=="" (
  ECHO ERROR: Missing required arguement ^<properties_file^>!
  GOTO USAGE
)
IF "%2"=="" (
  ECHO ERROR: Missing required arguement ^<property_name^>!
  GOTO USAGE
)
IF "%3"=="" (
  ECHO ERROR: Missing required arguement ^<env_var^>!
  GOTO USAGE
)


SET PROPERTIES_FILE=%1
SET PROPERTY_NAME=%2
SET ENV_VAR=%3
SET %ENV_VAR%=

FOR /F "usebackq delims== tokens=1-2" %%i IN (`findstr /b /c:"%PROPERTY_NAME%=" %PROPERTIES_FILE%`) DO SET %ENV_VAR%=%%j

GOTO :EOF

:USAGE
ECHO USAGE: %0 ^<properties_file^> ^<property_name^> ^<env_var^>
EXIT /B 1

