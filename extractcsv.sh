#!/bin/bash

while IFS= read -r SERVER; do
    echo "Processing $SERVER..."

    # Create a temporary copy owned by azureuser
    ssh -n azureuser@"$SERVER" \
        "sudo cp /tmp/*.csv /tmp/csv-download/ 2>/dev/null || true; sudo chown azureuser:azureuser /tmp/csv-download/*.csv 2>/dev/null || true"

    # Retrieve the files
    scp azureuser@"$SERVER":/tmp/csv-download/*.csv /tmp/

    # Clean up remote copies
    ssh -n azureuser@"$SERVER" \
        "sudo rm -f /tmp/csv-download/*.csv"

done < servers.txt
