@echo off
@
@rem This will start a POF Configuration Generator to generate a POF
@rem configuration based on annotated classes
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

set java_opts=-Xms%memory% -Xmx%memory% %java_opts%

%java_exec% %java_opts% -cp "%coherence_home%\lib\coherence.jar" com.tangosol.io.pof.generator.Executor %*

goto exit

:instructions

echo Usage:
echo   ^<coherence_home^>\bin\pof-config-gen.cmd
goto exit

:exit
endlocal
@echo on
