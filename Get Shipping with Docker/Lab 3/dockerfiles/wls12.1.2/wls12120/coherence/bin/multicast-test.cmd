@echo off
@
@rem This will start a multicast networking test for
@rem testing multicast communications between machines.
@
setlocal

:start
set coherence_home=%~dp0\..
if not exist "%coherence_home%\lib\coherence.jar" goto instructions

if "%java_home%"=="" (set java_exec=java) else (set java_exec=%java_home%\bin\java)

:launch

@echo on
"%java_exec%" -server -showversion -cp "%coherence_home%\lib\coherence.jar" com.tangosol.net.MulticastTest %*
@echo off

goto exit

:instructions

echo Usage:
echo   ^<coherence_home^>\bin\multicast-test.cmd
goto exit

:exit
endlocal
@echo on