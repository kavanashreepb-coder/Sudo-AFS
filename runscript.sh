#!/bin/bash

SCRIPT="sudo-AFS.sh"
REMOTE_PATH="/tmp/$SCRIPT"
USER="azureuser"

while IFS= read -r SERVER; do

    # Skip empty lines and comments
    [[ -z "$SERVER" || "$SERVER" =~ ^# ]] && continue

    echo "========================================"
    echo "Executing on $SERVER..."
    echo "========================================"

    # 1. Copy script to remote server
    echo "Copying $SCRIPT to $SERVER..."

    if ! scp -q "$SCRIPT" "$USER@$SERVER:$REMOTE_PATH"; then
        echo "$SERVER : FAILED - SCP"
        echo
        continue
    fi

    # 2. Execute script with sudo
    echo "Running $SCRIPT on $SERVER..."

    if ssh -o BatchMode=yes "$USER@$SERVER" \
        "sudo -n /bin/bash $REMOTE_PATH"; then

        echo "$SERVER : SUCCESS"

    else

        RC=$?
        echo "$SERVER : FAILED (exit code: $RC)"

    fi

    echo

done < servers.txt
