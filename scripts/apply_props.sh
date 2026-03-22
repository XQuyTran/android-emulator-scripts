#!/usr/bin/env bash
set -euo pipefail

ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"

# Connect to the emulator/device and wait until it's ready
adb connect "$ADB_TARGET" >/dev/null 2>&1 || true
adb -s "$ADB_TARGET" wait-for-device

# Push properties edit script to the device and execute it with root privileges
adb -s "$ADB_TARGET" push props.sh /sdcard/props.sh
adb -s "$ADB_TARGET" shell su 0 "mkdir -p /data/adb/service.d"
adb -s "$ADB_TARGET" shell su 0 "mv /sdcard/props.sh /data/adb/service.d/props.sh"
adb -s "$ADB_TARGET" shell su 0 "chmod 755 /data/adb/service.d/props.sh"
adb -s "$ADB_TARGET" shell su 0 "/data/adb/service.d/props.sh"
adb -s "$ADB_TARGET" shell su 0 "rm -f /data/adb/service.d/props.sh"

# Check properties
adb -s "$ADB_TARGET" shell getprop | grep -Ei 'userdebug|test-keys|redroid_'

adb -s "$ADB_TARGET" shell settings put system pointer_location 1
adb -s "$ADB_TARGET" shell settings put system show_touches 1