#!/bin/sh

usage() {
  echo "USAGE: $0 <properties_file> <property_name> <env_var>"
  exit 1
}

if [ "$1" = "" ]; then
  echo "Missing required arguement <properties_file>!"
  usage
fi
if [ "$2" = "" ]; then
  echo "Missing required arguement <property_name>!"
  usage
fi
if [ "$3" = "" ]; then
  echo "Missing required arguement <env_var>!"
  usage
fi


PROPERTIES_FILE=$1
PROPERTY_NAME=$2
ENV_VAR=$3

export ${ENV_VAR}=`grep ${PROPERTY_NAME} ${PROPERTIES_FILE} | cut -d '=' -f 2`

