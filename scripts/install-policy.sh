#!/bin/env bash

if [ $# -ne 1 ]; then
    echo "You must provide the name of the process for which you have generated an SELinux type enforcenment file for!"
    echo "For example: install-policy.sh iptables"
    exit 1
fi

echo "!!! Be sure to inspect the SELinux type enforcement file before proceeding !!!"

export COMMON_NAME=$1
export TE_FILE="$COMMON_NAME-selinux.te"
export POLICY_MOD="$COMMON_NAME.mod"
export POLICY_PP="$COMMON_NAME.pp"

# Check and compile module file
sudo checkmodule -M -m -o "$POLICY_MOD" "$TE_FILE"

# Generate policy package
sudo semodule_package -o "$POLICY_PP" -m "$POLICY_MOD"

# Install SELinux policy package
sudo semodule -i "$POLICY_PP"

SUCCESS=$(sudo semodule -l | grep $COMMON_NAME)

if [ -z "$SUCCESS" ]; then
    echo "The SELinux policy was NOT installed!"
else
    echo "The SELinux policy was installed!"
fi
