#!/bin/bash

_prog_name=$( basename $0 )
_log_level_string=( DEBUG INFO WARN ERR NONE )
_log_output_string=( STDOUT FILE BOTH )
_default_log_file="${_prog_name}_$( date +'%Y%m%d%H%M' ).log"

LOG_LEVEL_DEBUG=1
LOG_LEVEL_INFO=2
LOG_LEVEL_WARN=3
LOG_LEVEL_ERR=4
LOG_LEVEL_NONE=10

LOG_LEVEL=${LOG_LEVEL-$LOG_LEVEL_INFO}

LOG_DATE_FORMAT=${LOG_DATE_FORMAT-"%Y/%m/%d %H:%M:%S"}
LOG_FILE=${LOG_FILE-$_default_log_file}

LOG_OUTPUT_STDOUT=1
LOG_OUTPUT_FILE=2
LOG_OUTPUT_BOTH=3
LOG_OUTPUT=$LOG_OUTPUT_STDOUT

function _log() {
  local msg="$( date +"$LOG_DATE_FORMAT" ) ${_prog_name}($$) $*"
  case $LOG_OUTPUT in
    $LOG_OUTPUT_STDOUT)
      echo $msg;;
    $LOG_OUTPUT_FILE)
      echo $msg >> $LOG_FILE;;
    $LOG_OUTPUT_BOTH)
      echo $msg | tee -a $LOG_FILE;;
  esac
}

function LOG_DEBUG() {
  if [ $LOG_LEVEL_DEBUG -ge $LOG_LEVEL ]; then
    _log "DEBUG" $*
  fi
}

function LOG_INFO() {
  if [ $LOG_LEVEL_INFO -ge $LOG_LEVEL ]; then
    _log "INFO" $*
  fi
}

function LOG_WARN() {
  if [ $LOG_LEVEL_WARN -ge $LOG_LEVEL ]; then
    _log "WARN" $*
  fi
}

function LOG_ERR() {
  if [ $LOG_LEVEL_ERR -ge $LOG_LEVEL ]; then
    _log "ERROR" $*
  fi
}

function SET_LOG_LEVEL_FROM_ARGV() {
  local optind=1 count=1 opt level
  while [ $count -le $# ]; do
    opt="${!optind}"
    if [ "$opt" == "-L" ]; then
        optind=$(( optind + 1 ))
        level=${!optind}
        if [ -z "$level" ]; then
          echo "log4bash error: No log level defined."
          exit 1
        fi
        case "$level" in
          DEBUG)
            LOG_LEVEL=$LOG_LEVEL_DEBUG
            ;;
          INFO)
            LOG_LEVEL=$LOG_LEVEL_INFO
            ;;
          WARN)
            LOG_LEVEL=$LOG_LEVEL_WARN
            ;;
          ERR)
            LOG_LEVEL=$LOG_LEVEL_ERR
            ;;
          NONE)
            LOG_LEVEL=$LOG_LEVEL_NONE
            ;;
          *)
            echo "log4bash error: Invalid log level (${level}). Valid levels are ${_log_level_string[@]}."
            exit 1
            ;;
        esac
        break
    fi
    optind=$(( optind + 1 ))
    count=$(( count + 1 ))
  done
}

function LOG_LEVEL_STRING() {
  local ind=$(( $1 - 1 )); echo ${_log_level_string[$ind]}
}

function LOG_OUTPUT_STRING() {
  local ind=$(( $1 - 1 )); echo ${_log_output_string[$ind]}
}

function LOG4BASH_INFO() {
  echo "log4bash"
  echo ">>> LOG_LEVEL  = $( LOG_LEVEL_STRING $LOG_LEVEL )"
  echo ">>> LOG_OUTPUT = $( LOG_OUTPUT_STRING $LOG_OUTPUT )"
  echo ">>> LOG_FILE   = $LOG_FILE"
  echo
}