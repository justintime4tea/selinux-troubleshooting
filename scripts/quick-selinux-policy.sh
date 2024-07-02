#!/bin/env bash

if [ $# -ne 1 ]; then
    echo "You must provide the path to the executable you wish to add SELinux policy for!"
    echo "For example: quick-selinux-policy.sh /usr/bin/rulebreaker"
    exit 1
fi


export PROCESS_PATH=$1

if [ ! -f "$PROCESS_PATH" ]; then
    echo "Could not find \"$PROCESS_PATH\""
fi

export COMMON_NAME=$(echo "$PROCESS_PATH" | rev | cut -d'/' -f1 | rev)
export POLICY_DIR="fedora/fc40/$COMMON_NAME-selinux-1.0.0"

if [ -f "$POLICY_DIR/$COMMON_NAME.sh" ]; then
    cd "$POLICY_DIR" || exit
    ./"$COMMON_NAME".sh --update
    exit 0
fi

echo "Creating SELinux policy package directory for: $COMMON_NAME"
echo "Executable found: $PROCESS_PATH"

mkdir -p "$POLICY_DIR"
if [ ! -f "$POLICY_DIR/Makefile" ]; then
    echo "Generating $COMMON_NAME Makefile"
    sed "s/foobar/$COMMON_NAME/g" Makefile.template > "$POLICY_DIR/Makefile"
fi

cd "$POLICY_DIR" || exit

if [ ! -f "$COMMON_NAME.sh" ]; then
    echo "Generating SELinux policy files"
    sepolicy generate --init "$PROCESS_PATH"
    tree
fi

echo "Finished setting up new SELinux policy directory"
exit 0
