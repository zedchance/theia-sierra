#!/bin/bash

# Config
INACTIVE="All frontend contributions have been stopped"
TIMEOUT=1800

# Loop thru running containers
for CONTAINER in $(docker ps --format "{{.Names}}")
do
    # Get latest log entry
    LOG=$(docker container logs -t -n 1 "$CONTAINER")

    # Timestamp is the first 30 chars of the log
    TIMESTAMP=${LOG:0:19}

    # Debug
    # echo ""
    # echo "Container ID: $CONTAINER"
    # echo "Log: ${LOG:31:100}"
    # echo "Timestamp: $TIMESTAMP"

    # Check to see if the log entry is the inactive message
    if [[ $LOG == *"$INACTIVE"* ]]
    then
        echo "Closed container found: $CONTAINER"

        # Current time
        NOW=$(date +%s)

        # Date command on macOS
        THEN=$(date -jf "%Y-%m-%dT%H:%M:%S" "$TIMESTAMP" "+%s")
        # Date command on linux
        # THEN=$(date -d "$TIMESTAMP" +%s)

        # Calculate idle time
        # +28800 to compensate for PST to UTC, fix this
        DIFF=$((NOW - THEN + 28800))
        IDLE_MIN=$((DIFF / 60))

        # Debug
        # echo "    Now : $NOW"
        # echo "    Then: $THEN"
        # echo "    Diff: $DIFF"
        echo "    $CONTAINER has been idle for $IDLE_MIN minutes"

        if [[ $DIFF -gt $TIMEOUT ]]
        then
            echo "    $CONTAINER has exceeded time out, stopping..."
            docker stop "$CONTAINER" > /dev/null
        fi
    fi
done
