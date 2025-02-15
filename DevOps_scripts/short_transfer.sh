#!/bin/bash

# Variables
LOCAL_FILE="$1"
REMOTE_DIR="$2"
SERVER_NAME="$3"

# Transfer file
scp "$LOCAL_FILE" "$SERVER_NAME":"$REMOTE_DIR"

echo "File '$LOCAL_FILE' transferred to '$REMOTE_DIR' on EC2 instance."


#Using rsync for More Efficient Transfers
 #For more advanced file transfers, especially when dealing with large files or directories, rsync is a powerful tool.
 #
 #Basic rsync Usage
 #Sync Local Directory to Remote Server:
 #
 #bash
 #rsync -avz /path/to/local/directory/ aws:/path/to/remote/destination/
 #Example:
 #
 #bash
 #rsync -avz ~/Pictures/ aws:~/images/
 #Explanation: Synchronizes your local Pictures directory with the images directory on the EC2 instance.
 #
 #Sync Remote Directory to Local Machine:
 #
 #bash
 #rsync -avz aws:/path/to/remote/directory/ /path/to/local/destination/
 #Example:
 #
 #bash
 #rsync -avz aws:~/data/ ~/DataBackup/
 #Benefits of Using rsync
 #Efficiency: Transfers only the differences between source and destination.
 #
 #Compression: The -z option compresses data during transfer.
 #
 #Preserves Permissions: The -a (archive) option maintains file permissions and timestamps.
 #
 #Verbose Output: The -v option provides detailed information about the transfer process.