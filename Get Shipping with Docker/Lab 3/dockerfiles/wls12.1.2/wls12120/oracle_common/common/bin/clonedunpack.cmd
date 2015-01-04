@ECHO OFF
SETLOCAL

SET SCRIPT_PATH=%~dp0
FOR %%i IN ("%SCRIPT_PATH%") DO SET SCRIPT_PATH=%%~fsi

if exist %SCRIPT_PATH%\cam_clonedunpack.cmd (
  call %SCRIPT_PATH%\cam_clonedunpack.cmd %*
  EXIT /B
)

@REM Set the ORACLE_HOME relative to this script...
FOR %%i IN ("%SCRIPT_PATH%\..\..") DO SET ORACLE_HOME=%%~fsi

@REM Set the MW_HOME relative to the ORACLE_HOME...
FOR %%i IN ("%ORACLE_HOME%\..") DO SET MW_HOME=%%~fsi

@REM Set the home directories...
CALL "%SCRIPT_PATH%\setHomeDirs.cmd"

CALL "%SCRIPT_PATH%\commEnv.cmd"

SET CLASSPATH=%FMWCONFIG_CLASSPATH%;%DERBY_CLASSPATH%;%POINTBASE_CLASSPATH%

if /I "%1"=="-help" (
  GOTO :RUN
)

:PARSEARGS
SET VALIDATE=%2
FOR %%I IN (%VALIDATE%) DO SET VALIDATE=%%~I
if NOT {%1}=={} (
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
@REM Since we must change directories prior to running clonedunpack, convert file
@REM paths to absolute.  Also use short names to avoid problems with spaces
@REM in names
FOR %%I IN (%ARGVALUE%) DO SET FILEARGVALUE=%%~FSI
IF /i "%ARGNAME%"=="-log" (
  SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%FILEARGVALUE% 
  GOTO :PARSEARGS
) 
IF  /i "%ARGNAME%"=="-domain" (
  SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%FILEARGVALUE% 
  GOTO :PARSEARGS
)
IF  /i "%ARGNAME%"=="-template" (
  SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%FILEARGVALUE% 
  GOTO :PARSEARGS
)
IF  /i "%ARGNAME%"=="-app_dir" (
  SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%FILEARGVALUE% 
  GOTO :PARSEARGS
)
IF  /i "%ARGNAME%"=="-pathmap" (
  SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%FILEARGVALUE% 
  GOTO :PARSEARGS
)
IF  /i "%ARGNAME%"=="-admin_domain" (
  SET ARGUMENTS=%ARGUMENTS% %ARGNAME%=%FILEARGVALUE% 
  GOTO :PARSEARGS
)

FOR %%I IN (%ARGVALUE%) DO SET FILEARGVALUE=%%~I
SET ARGUMENTS=%ARGUMENTS% %ARGNAME%="%ARGVALUE%"
GOTO :PARSEARGS

:RUN
PUSHD %COMMON_COMPONENTS_HOME%\common\lib

SET JVM_ARGS=-Dprod.props.file="%WL_HOME%\.product.properties" %MEM_ARGS% %CONFIG_JVM_ARGS% -DCOMMON_COMPONENTS_HOME=%COMMON_COMPONENTS_HOME%

IF EXIST %JAVA_HOME% (
 %JAVA_HOME%\bin\java -Dcloned.unpack.mode=true %JVM_ARGS% com.oracle.cie.domain.script.Unpacker %ARGUMENTS%
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
