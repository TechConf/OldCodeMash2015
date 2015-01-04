@rem *************************************************************************
@rem This script is used to uninstall a NodeManager Windows Service.
@rem
@rem This script sets the following variables before uninstalling 
@rem the Windows Service:
@rem
@rem WL_HOME    - The root directory of your WebLogic installation
@rem *************************************************************************

@echo off
SETLOCAL

set WL_HOME=%MW_HOME%\wlserver
@rem *** commEnv.cmd may affect install service name by abbreviating WL_HOME
@rem *** so we must call it here to be same as installNodeMgrSvc.cmd
call "%WL_HOME%\..\oracle_common\common\bin\commEnv.cmd"

if "%PROD_NAME%"=="" (
  set PROD_NAME=@PROD_NAME
) else (
  echo PROD_NAME is already set to %PROD_NAME% 
)
if "%PROD_NAME%"=="@PROD_NAME" (
  set PROD_NAME="OracleWebLogic"
)
set BAR_WL_HOME=%WL_HOME:\=_%
set BAR_WL_HOME=%BAR_WL_HOME::=%


rem *** Uninstall the service
"%WL_HOME%\server\bin\wlsvc" -remove -svcname:"%PROD_NAME% NodeManager (%BAR_WL_HOME%)"

ENDLOCAL

