#!/bin/bash

SCRIPT="realtime.scd"
SCLANG="/Applications/SuperCollider/SuperCollider.app/Contents/Resources/sclang"
LOG=sotg.log

rm -f $LOG
echo "logging to $LOG"

while true; do
    $SCLANG $SCRIPT > $LOG

    sleep 1

    killall scsynth

    sleep 1
done