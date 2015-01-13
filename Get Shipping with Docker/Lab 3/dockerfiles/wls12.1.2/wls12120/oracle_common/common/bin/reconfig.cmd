@ECHO OFF
SETLOCAL

IF "%USER_MEM_ARGS%" == "" (
  ECHO Must set USER_MEM_ARGS prior to running this script
  EXIT /B 1
)

FOR /f %%i in ('cd') do set MYPWD=%%i

SET SCRIPT_PATH=%~dp0
FOR %%i IN ("%SCRIPT_PATH%") DO SET SCRIPT_PATH=%%~fsi

@REM Set the ORACLE_HOME relative to this script...
FOR %%i IN ("%SCRIPT_PATH%\..\..") DO SET ORACLE_HOME=%%~fsi

@REM Set the MW_HOME relative to the ORACLE_HOME...
FOR %%i IN ("%ORACLE_HOME%\..") DO SET MW_HOME=%%~fsi

@REM Set the home directories...
CALL "%SCRIPT_PATH%\setHomeDirs.cmd"

@REM Set the config jvm args...
SET CONFIG_JVM_ARGS=%CONFIG_JVM_ARGS% -DCOMMON_COMPONENTS_HOME=%COMMON_COMPONENTS_HOME%

CALL "%SCRIPT_PATH%\commEnv.cmd"

FOR %%i IN ("%JAVA_HOME%") DO SET JAVA_HOME=%%~fsi

SET CLASSPATH=%FMWCONFIG_CLASSPATH%;%DERBY_CLASSPATH%

:PARSEARGS
SET VALIDATE=%2
FOR %%I IN (%VALIDATE%) DO SET VALIDATE=%%~I
if NOT {%1}=={} (
  IF "%1"=="-help" (
    SET ARGUMENTS=%1
    GOTO :RUN
  )
  IF "%VALIDATE:~0,1%"=="-" (
    ECHO ERROR! Missing equal^(=^) sign. Arguments must be -name=value!
    EXIT /B 1
  )
  IF "%VALIDATE%"=="" (
    ECHO ERROR! Missing value! Arguments must be -name=value!
    EXIT /B 1
  )
  GOTO :SETARG
) ELSE (
  GOTO :RUN
)

:SETARG
SET ARGNAME=%1
SET ARGVALUE=%2
SHIFT
SHIFT
FOR %%I IN (%ARGVALUE%) DO SET ARGVALUE=%%~I
IF /i "%ARGNAME%"=="-log" (
  IF "%ARGVALUE:~1,1%"==":" (
    SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%ARGVALUE% 
  ) ELSE (    
    SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%MYPWD%\%ARGVALUE%  
  )  
  GOTO :PARSEARGS
) ELSE (
  IF  /i "%ARGNAME%"=="-silent_script" (
    IF "%ARGVALUE:~1,1%"==":" (
        SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%ARGVALUE% 
    ) ELSE (    
        SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%MYPWD%\%ARGVALUE%  
    )  
    GOTO :PARSEARGS
  ) ELSE (
    IF /i "%ARGNAME%"=="-useXACML" (
        SET MEM_ARGS=%MEM_ARGS% -DuseXACML=%ARGVALUE%
    ) ELSE (
      IF /i "%ARGNAME%"=="-target" (
        ECHO ERROR! Invalid value '-target'!
	EXIT /B 1
      ) ELSE (
        SET ARGUMENTS=%ARGUMENTS% %ARGNAME%="%ARGVALUE%"
      )
    )
    GOTO :PARSEARGS
  )
)
:RUN
PUSHD %COMMON_COMPONENTS_HOME%\common\lib
SET JVM_ARGS=-Dprod.props.file="%WL_HOME%\.product.properties" -Dpython.cachedir="%TEMP%\cachedir" %MEM_ARGS% %CONFIG_JVM_ARGS%

IF EXIST %JAVA_HOME% (
  IF "%ARGUMENTS%" == "" (
    %JAVA_HOME%\bin\javaw %JVM_ARGS% com.oracle.cie.wizard.WizardController -target=reconfig %ARGUMENTS%
  ) ELSE (
    %JAVA_HOME%\bin\java %JVM_ARGS% -Djdbc=true com.oracle.cie.wizard.WizardController -target=reconfig %ARGUMENTS%
  )
) ELSE (
  CALL :SET_RC 1
)

SET RETURN_CODE=%ERRORLEVEL%
POPD

IF DEFINED USE_CMD_EXIT (
  EXIT %RETURN_CODE%
) ELSE (
  EXIT /B %RETURN_CODE%
)

:SET_RC
EXIT /B %1
