#!/bin/bash

###
## nWrap.sh
## nagios passive alert wrapper
## rev 20061022 c3w@juicypop.net
## captures stdout/stderr posts script exist status to nagios

if [ ! ${4} ]; then {
cat <<EOF
###
## usage: nWrap.sh "my command with parms" [logfile] [nagioshost] [service]
## i.e. nWrap.sh "echo nwrap test" /tmp/ls.log nsx test

EOF
exit;
}; fi

COMMAND="${1}"
LOGFILE="${2}"
NAGIOSHOST="${3}"
NAGIOSSERVICE="${4}"
DATE_STR=$(date +"%Y%m%d")
NSCA_BIN="/usr/sbin/send_nsca"
NSCA_DELIMITER=":"
NSCA_CFG="/etc/nagios/send_nsca.cfg"

## run command with output logging
${COMMAND} >${LOGFILE} 2>&1
EXITSTAT=${?}

## pass exit status to nagios, with last line from logfile
OUTPUT="$(tail -1 ${LOGFILE})"
echo "${HOSTNAME}:${NAGIOSSERVICE}:${EXITSTAT}:${OUTPUT}" |\
	${NSCA_BIN} -H ${NAGIOSHOST} -d ${NSCA_DELIMITER} -c ${NSCA_CFG} \
	>/dev/null 2>&1

