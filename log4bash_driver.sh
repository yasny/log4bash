#!/bin/bash

. ./log4bash.sh

SET_LOG_LEVEL_FROM_ARGV $*
LOG4BASH_INFO

while getopts ":ab" o; do
  case "$o" in
    a)
      echo "Option a"
      ;;
    b)
      echo "Option b"
      ;;
    \?)
      if [ $OPTARG == "L" ]; then
        OPTIND=$(( OPTIND + 1 ))
        continue
      fi
      echo "Unknown option $OPTARG"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

echo "First arg = $1"
echo "LOG_LEVEL = $( LOG_LEVEL_STRING $LOG_LEVEL )"
LOG_DEBUG "This is a DEBUG message"
LOG_INFO "This is an INFO message"
LOG_WARN "This is a WARN message"
LOG_ERR "This is an ERR message"

echo "Changing date format..."
LOG_DATE_FORMAT="%m/%d/%y"
LOG_DEBUG "This is a DEBUG message"
LOG_INFO "This is an INFO message"
LOG_WARN "This is a WARN message"
LOG_ERR "This is an ERR message"

echo "Changing LOG_OUTPUT to BOTH..."
LOG_OUTPUT=$LOG_OUTPUT_BOTH
LOG4BASH_INFO
LOG_DEBUG "This is a DEBUG message"
LOG_INFO "This is an INFO message"
LOG_WARN "This is a WARN message"
LOG_ERR "This is an ERR message"

