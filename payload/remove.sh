#!/bin/bash

# This script uninstalls the udp-bcast-relay

# Set up the EdgeOS environment
source /opt/vyatta/etc/functions/script-template
shopt -s expand_aliases
alias show='_vyatta_op_run show'
alias run='/opt/vyatta/bin/vyatta-op-cmd-wrapper'
alias check='/bin/cli-shell-api'

# You must be root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as sudo or root" 1>&2
   exit 1
fi

# Check to see if bcast-relay is still configured and bail if it is
check existsActive service bcast-relay
if [[ $? -eq 0 ]]; then
   echo "[service bcast-relay] must be deleted from the configuration before removing the program" 1>&2
   exit 1
fi

progname='udp-bcast-relay'
target='/config/scripts'

echo "Stopping ubnt-bcast-relay service"
${target}/ubnt-bcast-relay.pl --stop

# Delete files
echo "Removing udp-bcast-relay-rs from /opt/vyatta/sbin/"
rm /opt/vyatta/sbin/udp-bcast-relay-rs
echo "Removing udp-bcast-relay.pl from ${target}/ubnt-bcast-relay.pl"
rm ${target}/ubnt-bcast-relay.pl
echo "Removing ubnt-bcast-relay templates from ${basedir}/templates-cfg/service/"
rm -rf /opt/vyatta/share/vyatta-cfg/templates/service/bcast-relay

# Finished
echo "Uninstall of $progname complete."

