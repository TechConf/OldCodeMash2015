@ECHO OFF
if defined DEBUG @echo on

@REM
@REM Additional commands to support node manager ip migration.
@REM

@REM Parse command and options
if [%1]==[] CALL :usage_error

set COMMAND=
set INTERFACE=
set ADDRESS=
set MASKVALUE=
set ERRORLEVEL=
set IPV6=
set IP=

if [%1] == [-addif] (
   set COMMAND=addif
   set INTERFACE=%2%
   set ADDRESS=%3%
   set MASKVALUE=%4%
   if not defined INTERFACE call :usage_error
   if not defined ADDRESS call :usage_error
   call :detect_IPV6
   if [%IPV6%] == [-IPv4] (
     if not defined MASKVALUE call :usage_error
   )  
   call :setIP
)


if [%1] == [-removeif] (
   set COMMAND=removeif
   set INTERFACE=%2%
   set ADDRESS=%3%
   if not defined INTERFACE call :usage_error
   if not defined ADDRESS call :usage_error
   call :detect_IPV6
   call :setIP
)

if [%1] == [-listif] (
   set COMMAND=listif
   set IPV6=%2%
   set INTERFACE=%3%
   if not defined INTERFACE call :usage_error
   call :setIP
)

@REM internal usage only
if [%1] == [-test] (
   call %2 %3 %4 %5 %6 %7 %8
   goto :EOF
)

@REM Must have specified at least one command
if not defined COMMAND CALL :usage_error

set NullDevice=nul

@REM *********************************************************************
@REM Set this to true if IP address should not be online before starting
@REM a server.  Otherwise, presence of an IP address in an interface will
@REM cause the script to report success on IP addif
set ENABLESTRICTIPCHECK=N

if not defined ServerName set ServerName=myserver
if not defined ServerDir set ServerDir=%CD%
if not exist "%ServerDir%\data\nodemanager" mkdir "%ServerDir%\data\nodemanager"

set addrFile=
set addrFile=%ServerDir%\data\nodemanager\%ServerName%.addr

call :%COMMAND%
GOTO :EOF

@REM --- Start Functions ---
@REM *********************************************************************
@REM Set the correct ip value based on ipv6 or ipv4
:setIP
if [%IPV6%] == [-IPv6] (
  SET IP=ipv6
  if not defined MASKVALUE (
    set ADDRESS_AND_MASK=%ADDRESS%
  ) else (
    set ADDRESS_AND_MASK=%ADDRESS%/%MASKVALUE%
  )
) ELSE (
  SET IP=ip
  set ADDRESS_AND_MASK=%ADDRESS% %MASKVALUE%
)

GOTO :EOF


@REM *********************************************************************
@REM Show an error if the address does not show up in the address file
:address_error
SETLOCAL
ECHO Cannot remove %ADDRESS% - not brought online >&2
exit 1

@REM *********************************************************************
@REM Remove the given address from the interface specified
:removeif
SETLOCAL

@REM Store the contents of the address file as the %addr% var
if exist "%AddrFile%"  (
findstr %ADDRESS% %AddrFile% > null || call :address_error
)
netsh interface %IP% delete address %INTERFACE% addr=%ADDRESS%
set remExitVal=%ERRORLEVEL%
if not %remExitVal% == 0 (
 echo Unable to remove %ADDRESS% - Check command output for more details >&2
 call :cleanupAddressFile
 exit %remExitVal%
)
echo Successfully removed %ADDRESS% from %INTERFACE%.
call :cleanupAddressFile
GOTO :EOF



@REM *********************************************************************
@REM Show the correct message (info or error) if the given address is already
@REM on the specified interface.  This is normally an informative message
@REM unless ENABLESTRICTIPCHECK is set to something other then the default 'N'.
:already_online
if [%ENABLESTRICTIPCHECK%] == [N] (
echo %ADDRESS% already online on %INTERFACE%.  Please make sure that the IP address specified is not used by other servers/applications.  Continuing...
) ELSE (
echo %ADDRESS% already online on %INTERFACE%.  Please make sure that the IP address specified is not used by other servers/applications >&2
call :cleanupAddressFile
exit 1
)
GOTO :EOF

@REM *********************************************************************
@REM Show that an error occured calling the netsh utility
:add_error
SETLOCAL
echo Failed to bring %ADDRESS_AND_MASK% online on %INTERFACE% >&2
echo Check command output for more details >&2
exit 1
ENDLOCAL


@REM *********************************************************************
@REM Add the given address to the specified interface
:addif
SETLOCAL
set newif=
netsh interface %IP% show address %INTERFACE% | findstr /r /c:"[^ 	]*IP" > tmp_ip_file
for /F "usebackq tokens=3" %%G in ( tmp_ip_file ) do (
 if %%G == %ADDRESS% set newif=already-online
)
if not defined newif set newif=unmatched
del tmp_ip_file

if [%newif%] == [unmatched] (
 call :addnew
) ELSE call :already_online

if exist "%AddrFile%" call :cleanupAddressFile
echo %ADDRESS%>> "%AddrFile%"
ENDLOCAL
GOTO :EOF



@REM *********************************************************************
@REM For some reason catching the error value has problems when it is not in
@REM its own subroutine.  Setting addExitVal in the :addif routine leaves the
@REM variable as undefined causing extra error messages in the script output
@REM
:addnew
SETLOCAL
netsh interface %IP% add address %INTERFACE% %ADDRESS_AND_MASK%
set addExitVal=%ERRORLEVEL%
if not %addExitVal% == 0 call :add_error %addExitVal%
echo Successfully brought %ADDRESS_AND_MASK% online on %INTERFACE%
ENDLOCAL
GOTO :EOF


@REM *********************************************************************
@REM Check the %AddrFile% for %ADDRESS% and if it is there, then call the 
@REM subroutine to delete it
@REM
:cleanupAddressFile
SETLOCAL
if exist "%AddrFile%" (
findstr /x %ADDRESS% %AddrFile% > nul && CALL :removeAddressFromFile
)
ENDLOCAL
GOTO :EOF


@REM *********************************************************************
@REM Delete %ADDRESS% from the %AddrFile%
@REM
:removeAddressFromFile
SETLOCAL
set tmpAddr=addresses.tmp
for /F "delims=" %%a in (%AddrFile%) DO (
   if not %%a == %ADDRESS% (
	echo %%a>> %tmpAddr%
   )
)
del /f %AddrFile%
if exist %tmpAddr% (
  move %tmpAddr% %AddrFile%
)

ENDLOCAL
GOTO :EOF



@REM *********************************************************************
@REM List the IP addresses that are currently on the interface
:listif
netsh interface %IP% show address %INTERFACE% | findstr /r /c:"[^ 	]*IP"
GOTO :EOF


@REM *********************************************************************
@REM Show the correct usage of this script in the instance that someone
@REM called the script incorrectly
:usage_error
ECHO Usage: wlsifconfig.cmd >&2
ECHO      -addif {interface-name} {ip-address} {netmask or prefixlength} >&2
ECHO      -removeif {interface-name} {ip-address} >&2
ECHO      -listif -IPv4 or -IPv6 {interface-name} >&2
ECHO      'addif' adds {ip-address} to next available sub-interface of {interface-name}. >&2
ECHO      'removeif' removes {ip-address} from sub-interface of {interface-name}. >&2
ECHO      'listif' lists last used sub-interface of {interface-name} and its corresponding {ip-address} >&2
ECHO      To find the list of interfaces, use your following command to list the interface names- >&2
ECHO      netsh interface show interface. >&2
exit -101
GOTO :EOF


@REM *********************************************************************
@REM Check whether parameter IP address is ipv6. Return 0:IPv6; 1:not
@REM     %~1: the IP address to check
@REM     %~2: the var name to store result
:isIPv6 
SETLOCAL
set ipAddress=%~1
set retVale=1

if [%ipAddress%] == [] goto isIPv6__find_IPv4

echo %ipAddress% | find "::" >NUL 2>NUL
if "%errorlevel%"=="0" goto isIPv6__find_IPv6

for /F "tokens=1,2,3,4,5,6,7,8* delims=:" %%a in ("%ipAddress%") do set s1=%%a & set s2==%%b & set s3=%%c & set s4=%%d >NUL 2>NUL
if "%s4%" NEQ " " (
    goto isIPv6__find_IPv6
)

goto isIPv6__find_IPv4

:isIPv6__find_IPv4
set retVale=1
goto isIPv6__end

:isIPv6__find_IPv6
set retVale=0
goto isIPv6__end

:isIPv6__end
ENDLOCAL&set "%~2=%retVale%"
GOTO :EOF


@REM *********************************************************************
@REM Detect whether var ADDRESS is IPv6, and set IPV6 accordingly
:detect_IPV6
set isIPv6_result=1
call :isIPv6 %ADDRESS%, isIPv6_result
if [%isIPv6_result%] == [0] (
     set IPV6=-IPv6
) else (
     set IPV6=-IPv4
)
GOTO :EOF


:ENDFUNCTIONS

@REM --- End Functions ---
