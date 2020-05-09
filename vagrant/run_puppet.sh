#!/bin/sh

# Exit on any error
set -e

# Preparations required prior to "puppet apply".

usage() {
    echo
    echo "Usage: run_puppet.sh -b basedir"
    echo
    echo "Options:"
    echo " -b   Base directory for dependency Puppet modules installed by"
    echo "      librarian-puppet."
    echo " -m   Puppet manifests to run. Put them in the provision folder"
    exit 1
}

# Parse the options

# We are run without parameters -> usage
if [ "$1" = "" ]; then
    usage
fi

while getopts "b:m:h" options; do
    case $options in
        b ) BASEDIR=$OPTARG;;
	m ) MANIFESTS=$OPTARG;;
        h ) usage;;
        \? ) usage;;
        * ) usage;;
    esac
done

CWD=`pwd`

# Configure with "puppet apply"
PUPPET_APPLY="/opt/puppetlabs/bin/puppet apply --modulepath=$BASEDIR/modules"

# Pass variables to Puppet manifests via environment variables
export FACTER_profile='/etc/profile.d/openvpn.sh'
export FACTER_basedir="$BASEDIR"
export FACTER_zimbra_install_source='https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.RHEL7_64.20190918004220.tgz'

for manifest in $MANIFESTS; do
    $PUPPET_APPLY /vagrant/$manifest
done

cd $CWD
