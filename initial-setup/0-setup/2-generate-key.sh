#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


source ../env-global.sh

rm -f ./trillo-ssh ./trillo-ssh.pub
ssh-keygen -o -a 100 -t ed25519 -f ./trillo-ssh -C "sadmin" -N ''

touch $COMPLETED