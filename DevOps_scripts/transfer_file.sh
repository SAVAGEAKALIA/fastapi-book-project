#!/usr/bin/env bash
# Bash script that transfers a file from our client to a server
if [ "$#" -ne 4 ]; then
    echo "Usage: 0-transfer_file PATH_TO_FILE IP USERNAME PATH_TO_SSH_KEY"
    exit 1
fi

PATH_TO_FILE=$1
IP=$2
USERNAME=$3
PATH_TO_SSH_KEY=$4

scp -i "$PATH_TO_SSH_KEY" -o StrictHostKeyChecking=no "$PATH_TO_FILE" "$USERNAME@$IP:~/"
# Transfer file if you have configured ssh_config using aws as name in this case
#scp "$PATH_TO_FILE" aws:~
# scp -F "$PATH_TO_SSH_KEY" -o StrictHostKeyChecking=no "$PATH_TO_FILE" "$USERNAME@$IP:~/"