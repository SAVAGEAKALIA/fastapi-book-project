#!/usr/bin/env bash

# Print internal IP address
echo "Internal IP Address:"
hostname -I

# Print external IP address
echo "External IP Address:"
curl ifconfig.me
