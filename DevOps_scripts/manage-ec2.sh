#!/bin/bash

INSTANCE_ID="i-03c1bff31cca8f5c1"
ACTION=$1  # Pass 'start', 'stop', or 'reboot' as an argument

case "$ACTION" in
    start)
        aws ec2 start-instances --instance-ids $INSTANCE_ID
        echo "Instance $INSTANCE_ID started."
        ;;
    stop)
        aws ec2 stop-instances --instance-ids $INSTANCE_ID
        echo "Instance $INSTANCE_ID stopped."
        ;;
    reboot)
        aws ec2 reboot-instances --instance-ids $INSTANCE_ID
        echo "Instance $INSTANCE_ID rebooted."
        ;;
    status)
        aws ec2 describe-instance-status --instance-ids $INSTANCE_ID
        ;;
    *)
        echo "Usage: $0 {start|stop|reboot|status}"
        exit 1
        ;;
esac
