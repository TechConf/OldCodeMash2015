@echo off
@
@rem This will start a console application
@rem demonstrating the functionality of the Coherence(tm) API
@
setlocal

:config
@rem specify the Coherence installation directory
set coherence_home=%~dp0\..

@rem specify the jline installation directory
set jline_home=%coherence_home%\lib

@rem specify if the console will also act as a server
set storage_enabled=false

@rem specify the JVM heap size
set memory=64m


:start
if not exist "%coherence_home%\lib\coherence.jar" goto instructions

if "%java_home%"=="" (set java_exec=java) else (set java_exec=%java_home%\bin\java)


:launch

if "%storage_enabled%"=="true" (echo ** Starting storage enabled console **) else (echo ** Starting storage disabled console **)

set java_opts="-Xms%memory% -Xmx%memory% -Dtangosol.coherence.distributed.localstorage=%storage_enabled%"

"%java_exec%" -server -showversion "%java_opts%" -cp "%coherence_home%\lib\coherence.jar;%jline_home%\jline.jar" com.tangosol.coherence.dslquery.QueryPlus %*

goto exit

:instructions

echo Usage:
echo   ^<coherence_home^>\bin\query.cmd
goto exit

:exit
endlocal
@echo on
