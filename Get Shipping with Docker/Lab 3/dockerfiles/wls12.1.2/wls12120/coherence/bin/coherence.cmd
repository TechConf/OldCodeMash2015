@echo off
@
@rem This will start a console application
@rem demonstrating the functionality of the Coherence(tm) API
@
setlocal

:config
@rem specify the Coherence installation directory
set coherence_home=%~dp0\..

@rem specify if the console will also act as a server
set storage_enabled=false

@rem specify the JVM heap size
set memory=64m


:start
if not exist "%coherence_home%\lib\coherence.jar" goto instructions

if "%java_home%"=="" (set java_exec=java) else (set java_exec=%java_home%\bin\java)


:launch

if "%storage_enabled%"=="true" (echo ** Starting storage enabled console **) else (echo ** Starting storage disabled console **)

if "%1"=="-jmx" (
	set jmxproperties=-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true
	shift  
)	

set java_opts=-Xms%memory% -Xmx%memory% -Dtangosol.coherence.distributed.localstorage=%storage_enabled% %jmxproperties%

%java_exec% -server -showversion %java_opts% -cp "%coherence_home%\lib\coherence.jar" com.tangosol.net.CacheFactory %1

goto exit

:instructions

echo Usage:
echo   ^<coherence_home^>\bin\coherence.cmd
goto exit

:exit
endlocal
@echo on
