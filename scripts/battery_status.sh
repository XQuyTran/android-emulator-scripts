#!/usr/bin/env bash
set -euo pipefail

ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"

# Wait for device to be reachable
adb connect "$ADB_TARGET" >/dev/null 2>&1 || true

# Force all subsequent adb calls to use the same target
adb() { command adb -s "$ADB_TARGET" "$@"; }

adb wait-for-device

# Ensure ADB over TCP is active (paranoid check)
adb shell getprop ro.boot.qemu >/dev/null 2>&1 || true

# Avoid Android's "always charging 100%" giveaways
adb shell "dumpsys battery reset" || true

# Set an initial believable state
adb shell "dumpsys battery set status 3"   # discharging
adb shell "dumpsys battery set level 83"
adb shell "dumpsys battery set ac 0"
adb shell "dumpsys battery set usb 0"
adb shell "dumpsys battery set wireless 0"
adb shell "dumpsys battery set temp 297"   # 29.7°C

echo "[postboot] Initial battery set. Starting background randomizer & activity..."

# Background battery randomizer + light user activity
(
  while true; do
    # Randomize battery level 65–92%, temperature 28.0–33.5°C
    lvl=$(( 65 + RANDOM % 28 ))
    tmp=$(( 280 + RANDOM % 55 ))  # tenths of degree C
    # Occasionally "plug in" or "unplug"
    if (( RANDOM % 5 == 0 )); then
      # simulate briefly charging
      adb shell "dumpsys battery set ac 1; dumpsys battery set status 2" >/dev/null 2>&1 || true
    else
      adb shell "dumpsys battery set ac 0; dumpsys battery set status 3" >/dev/null 2>&1 || true
    fi
    adb shell "dumpsys battery set level $lvl; dumpsys battery set temp $tmp" >/dev/null 2>&1 || true

    # Light behavioral noise:
    #  - occasional HOME press
    #  - slow swipe to simulate scrolling
    if (( RANDOM % 3 == 0 )); then
      adb shell input keyevent 3            >/dev/null 2>&1 || true  # HOME
    fi
    adb shell input swipe 300 1800 300 400 $((200 + RANDOM % 500)) >/dev/null 2>&1 || true

    # Occasional rotation toggle to mimic sensor/orientation changes
    if (( RANDOM % 4 == 0 )); then
      # Toggle auto-rotate and rotate setting
      cur=$(adb shell settings get system accelerometer_rotation 2>/dev/null | tr -d '\r')
      if [ "$cur" = "1" ]; then
        adb shell settings put system accelerometer_rotation 0 >/dev/null 2>&1 || true
        adb shell settings put system user_rotation $((RANDOM % 4)) >/dev/null 2>&1 || true
      else
        adb shell settings put system accelerometer_rotation 1 >/dev/null 2>&1 || true
      fi
    fi

    # Sleep 5–12 minutes
    sleep $((300 + RANDOM % 420))
  done
) &

echo "[postboot] Background tasks started."