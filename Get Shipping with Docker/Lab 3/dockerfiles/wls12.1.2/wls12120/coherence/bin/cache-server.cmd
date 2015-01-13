@echo off
@
@rem This will start a cache server
@
setlocal

:config
@rem specify the Coherence installation directory
set coherence_home=%~dp0\..

@rem specify the JVM heap size
set memory=512m


:start
if not exist "%coherence_home%\lib\coherence.jar" goto instructions

if "%java_home%"=="" (set java_exec=java) else (set java_exec=%java_home%\bin\java)


:launch

if "%1"=="-jmx" (
	set jmxproperties=-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true
	shift  
)	

set java_opts=-Xms%memory% -Xmx%memory% %jmxproperties%

%java_exec% -server -showversion %java_opts% -cp "%coherence_home%\lib\coherence.jar" com.tangosol.net.DefaultCacheServer %1

goto exit

:instructions

echo Usage:
echo   ^<coherence_home^>\bin\cache-server.cmd
goto exit

:exit
endlocal
@echo on
