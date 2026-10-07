#!/bin/bash

set -e

REMOTE_USER="azureuser"
REMOTE_DIR="/tmp"
LOCAL_DIR="sudo_results"
IP_FILE="ips.txt"

mkdir -p "$LOCAL_DIR"

while IFS= read -r IP; do

    # Skip empty lines and comments
    [[ -z "$IP" || "$IP" =~ ^# ]] && continue

    echo "========================================"
    echo "Processing server: $IP"
    echo "========================================"

    echo "Setting permissions on CSV files..."
    ssh "${REMOTE_USER}@${IP}" <<EOF
sudo chmod 755 ${REMOTE_DIR}/*.csv
EOF

    echo "Copying CSV files from $IP..."

    # Create a separate directory for each server
    SERVER_DIR="${LOCAL_DIR}/${IP}"
    mkdir -p "$SERVER_DIR"

    scp "${REMOTE_USER}@${IP}:${REMOTE_DIR}/*.csv" "$SERVER_DIR/"

    echo "Completed: $IP"
    echo

done < "$IP_FILE"

echo "========================================"
echo "All servers processed successfully."
echo "CSV files are available under: $LOCAL_DIR"
echo "========================================"
