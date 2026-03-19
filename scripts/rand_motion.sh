#!/usr/bin/env bash

ADB="adb"
APP_LIST="apps.txt"

MIN_INTERVAL=480
MAX_INTERVAL=900

random_delay() {
  sleep $(( MIN_INTERVAL + RANDOM % (MAX_INTERVAL - MIN_INTERVAL) ))
}

random_app() {
  mapfile -t APPS < "$APP_LIST"
  IDX=$(( RANDOM % ${#APPS[@]} ))
  echo "${APPS[$IDX]}"
}

open_random_app() {
  APP=$(random_app)
  echo "[PeriodicMotion] Opening app: $APP"
  $ADB shell am start -n "$APP"
}

open_and_scroll() {
  open_random_app
  sleep 2
  X=$(( 300 + RANDOM % 200 ))
  $ADB shell input swipe $X 1600 $X 1200 350
}

random_tap() {
  X=$(( 200 + RANDOM % 600 ))
  Y=$(( 400 + RANDOM % 1000 ))
  $ADB shell input tap $X $Y
}

random_swipe() {
  X=$(( 300 + RANDOM % 200 ))
  $ADB shell input swipe $X 1500 $X 400 350
}

random_rotation() {
  ROT=$(( RANDOM % 4 ))
  $ADB shell settings put system accelerometer_rotation 0
  $ADB shell settings put system user_rotation $ROT
}

random_action() {
  case $(( RANDOM % 5 )) in
    0) random_tap ;;
    1) random_swipe ;;
    2) random_rotation ;;
    3) open_random_app ;;
    4) open_and_scroll ;;
  esac
}

echo "[PeriodicMotion] Starting periodic motion simulation..."

while true; do
  random_action
  random_delay
done