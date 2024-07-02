#!/bin/env bash

if [ $# -ne 1 ]; then
    echo "You must provide the name of the process you wish to generate an SELinux type enforcenment file for!"
    echo "For example: create-te.sh iptables"
    exit 1
fi

export COMMON_NAME=$1
export TE_FILE="$COMMON_NAME-selinux.te"

# Generate type enforcement file
sudo ausearch -c "$COMMON_NAME" --raw | sudo audit2allow -a -m "$COMMON_NAME" -o "$TE_FILE"

echo "!!! Be sure to inspect the SELinux type enforcement file before using it !!!"
