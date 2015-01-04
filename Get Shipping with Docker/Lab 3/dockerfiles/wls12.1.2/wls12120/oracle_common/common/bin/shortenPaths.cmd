@rem **************************************************************************
@rem This script is used to shorten CLASSPATH and PATH environmental variables.
@rem 
@rem Copyright (c) 2011, Oracle and/or its affiliates. All rights reserved. 
@rem **************************************************************************

if NOT "%CLASSPATH%"=="" (
  call :handle_classpath
)

if NOT "%PATH%"=="" (
  call :handle_path
)
goto :EOF

:handle_classpath
  set __SHORT_CLASSPATH__=
  call :process_classpath "%CLASSPATH%"
  set CLASSPATH=%__SHORT_CLASSPATH__%
  goto :EOF

:handle_path
  set __SHORT_PATH__=
  call :process_path "%PATH%"
  set PATH=%__SHORT_PATH__%
  goto :EOF
  
:process_classpath
  FOR /F "TOKENS=1,* DELIMS=;" %%a IN (%1) DO (
    if NOT "%%a"=="" (
      if exist "%%a" (
        call :add_to_classpath %%~fsa
      )
    )
    if NOT "%%b"=="" (
      call :process_classpath "%%b"
    )
  )
  goto :EOF

:add_to_classpath
  if NOT "%1"=="" (
    if NOT "%__SHORT_CLASSPATH__%"=="" (
      set __SHORT_CLASSPATH__=%__SHORT_CLASSPATH__%;%1
    ) else (
      set __SHORT_CLASSPATH__=%1
    )
  )
  goto :EOF

:process_path
  FOR /F "TOKENS=1,* DELIMS=;" %%a IN (%1) DO (
    if NOT "%%a"=="" (
      if exist "%%a" (
        call :add_to_path %%~fsa
      )
    )
    if NOT "%%b"=="" (
      call :process_path "%%b"
    )
  )
  goto :EOF

:add_to_path
  if NOT "%1"=="" (
    if NOT "%__SHORT_PATH__%"=="" (
      set __SHORT_PATH__=%__SHORT_PATH__%;%1
    ) else (
      set __SHORT_PATH__=%1
    ) 
  )
