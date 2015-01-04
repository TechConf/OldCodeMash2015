@rem *************************************************************************
@rem This script is used to uninstall a WebLogic Server Windows Service.
@rem
@rem To create your own start script for your domain, simply set the 
@rem SERVER_NAME variable to your server name then call this script from your
@rem domain directory.
@rem
@rem This script sets the following variables before uninstalling 
@rem the Windows Service:
@rem
@rem WL_HOME    - The root directory of your WebLogic installation
@rem
@rem For additional information, refer to "Managing Server Startup and Shutdown for Oracle WebLogic Server"
@rem (@DOCSWEBROOT/START/overview.htm).
@rem *************************************************************************

@echo off
SETLOCAL

set WL_HOME=%MW_HOME%\wlserver

rem *** Uninstall the service
"%WL_HOME%\server\bin\wlsvc" -remove -svcname:"wlsvc %DOMAIN_NAME%_%SERVER_NAME%"

ENDLOCAL
