IF NOT DEFINED MW_HOME (
 IF NOT DEFINED WL_HOME (
  echo MW_HOME or WL_HOME is not set
  IF DEFINED USE_CMD_EXIT (
   EXIT 1
  ) ELSE (
   EXIT /B 1
  )
 )
)

IF NOT DEFINED MW_HOME set MW_HOME=%WL_HOME%\..
FOR %%i IN ("%MW_HOME%") DO SET MW_HOME=%%~fsi

CALL "%MW_HOME%\oracle_common\common\bin\commEnv.cmd"
