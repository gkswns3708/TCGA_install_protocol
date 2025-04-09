#!/bin/bash

# GDC Client Parallel Download Script with Retry Handling
# Author: 최한준
# Date: 2025-03-30

# Set the maximum number of retries for failed downloads
RETRY_AMOUNT=5

# Set the number of parallel downloads
NUM_PARALLEL=5

# Directory containing split manifest files
MANIFEST_DIR="/mnt/Code/Data/manifest_svs_gene_counts"

# Log file for tracking download progress
LOG_FILE="/mnt/gdc_download.log"

# Path to the GDC user token file
TOKEN_FILE="/mnt/gdc-user-token.2025-03-27T11_45_22.329Z.txt"

# Variable to skip the first file
SKIP_FIRST=true

# Loop over all manifest files in the specified directory
for file in "$MANIFEST_DIR"/manifest_part_*; do
    # Check if this is the first file and skip it if needed
    if [ "$SKIP_FIRST" = true ]; then
        echo "Skipping first manifest file: $file"
        SKIP_FIRST=false
        continue
    fi

    echo "Starting download for manifest file: $file"
    
    gdc-client download -m "$file" \
    --log-file "$LOG_FILE" \
    --token-file "$TOKEN_FILE" \
    -n $NUM_PARALLEL \
    --retry-amount $RETRY_AMOUNT
    
    echo "Completed download for manifest file: $file"
    echo "--------------------------------------------"
done

# Indicate completion
echo "All downloads completed."
