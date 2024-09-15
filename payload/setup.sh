#!/bin/bash

# Script installs ubnt-bcast-relay and integrates it with the CLI

# You must be root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as sudo (root)" 1>&2
   exit 1
fi

basedir=$(dirname $0)
target='/config/scripts'

# Copy binary into /opt/vyatta/sbin
echo "Installing udp-bcast-relay-rs to /opt/vyatta/sbin/"
install -o root -g root -m 0755 ${basedir}/binaries/udp-bcast-relay-rs /opt/vyatta/sbin/udp-bcast-relay

# Copy config helper script into /opt/vyatta/sbin
echo "Installing ubnt-bcast-relay.pl to ${target}/"
install -o root -g root -m 0755 ${basedir}/scripts/ubnt-bcast-relay.pl ${target}/ubnt-bcast-relay.pl

# Copy vyatta-cfg templates
echo "Copying ubnt-bcast-relay templates to ${basedir}/templates-cfg/service/bcast-relay"
cp -r ${basedir}/templates-cfg/service/bcast-relay /opt/vyatta/share/vyatta-cfg/templates/service/
chown -R root:root /opt/vyatta/share/vyatta-cfg/templates/service/bcast-relay
