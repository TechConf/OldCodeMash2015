if [ -z "${MW_HOME}" -a -z "${WL_HOME}" ]; then
 echo "MW_HOME or WL_HOME is not set."
 exit 1
fi

if [ -z "${MW_HOME}" ]; then
  MW_HOME="${WL_HOME}/.."
fi

. "${MW_HOME}/oracle_common/common/bin/commEnv.sh"
