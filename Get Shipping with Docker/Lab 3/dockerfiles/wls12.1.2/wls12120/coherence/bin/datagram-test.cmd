@echo off
@
@rem This will start a datagram networking test for
@rem testing network throughput between machines.
@
setlocal

:start
set coherence_home=%~dp0\..
if not exist "%coherence_home%\lib\coherence.jar" goto instructions

if "%java_home%"=="" (set java_exec=java) else (set java_exec=%java_home%\bin\java)

:launch

@echo on
"%java_exec%" -server -showversion -cp "%coherence_home%\lib\coherence.jar" com.tangosol.net.DatagramTest %*
@echo off

goto exit

:instructions

echo Usage:
echo   ^<coherence_home^>\bin\datagram-test.cmd
goto exit

:exit
endlocal
@echo on