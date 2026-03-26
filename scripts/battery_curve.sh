#!/system/bin/sh

sleep 10

# Helper to read if screen is on
is_screen_on() {
    local STATE
    STATE=$(dumpsys power | grep "Display Power" | grep "state=")
    echo "$STATE" | grep -q "ON"
}

# Random sleep interval generator
rand_interval() {
    echo $(( 60 + RANDOM % 60 ))   # 60–119 seconds
}

# Random micro temperature drift
update_temp() {
    local TEMP=$((305 + RANDOM % 20))   # 30.5°C – 32.4°C
    dumpsys battery set temp $TEMP
}

# Main loop
while true; do

    # Read current battery %
    LEVEL=$(dumpsys battery | grep level | awk '{print $2}')

    # Decide charging state occasionally
    CHANCE=$((RANDOM % 30))
    if [ "$CHANCE" -eq 0 ]; then
        # Toggle charging
        if dumpsys battery | grep -q "status: 1"; then
            # Currently charging → stop charging
            dumpsys battery set status 3
            dumpsys battery set ac 0
            dumpsys battery set usb 0
        else
            # Start charging
            dumpsys battery set status 1
            dumpsys battery set ac 1
        fi
    fi

    # Check if charging
    CHARGING=$(dumpsys battery | grep status | awk '{print $2}')

    # SCREEN-ON DRAIN CURVE
    if [ "$CHARGING" -ne 1 ] && is_screen_on; then
        # Drain faster
        DROP=$((1 + RANDOM % 3))  # 1–3% per cycle
        NEW=$((LEVEL - DROP))
        [ "$NEW" -lt 10 ] && NEW=10      # never drain to fully dead
        dumpsys battery set level $NEW
    fi

    # SCREEN-OFF DRAIN CURVE
    if [ "$CHARGING" -ne 1 ] && ! is_screen_on; then
        DROP=$((RANDOM % 2))             # 0–1% small drain
        NEW=$((LEVEL - DROP))
        [ "$NEW" -lt 15 ] && NEW=15
        dumpsys battery set level $NEW
    fi

    # CHARGING CURVE
    if [ "$CHARGING" -eq 1 ]; then
        if [ "$LEVEL" -lt 80 ]; then
            INC=$((2 + RANDOM % 3))   # 2–4% fast charge
        elif [ "$LEVEL" -lt 95 ]; then
            INC=$((1 + RANDOM % 2))   # 1–2% moderate
        else
            INC=1                     # trickle
        fi

        NEW=$((LEVEL + INC))
        [ "$NEW" -gt 100 ] && NEW=100
        dumpsys battery set level $NEW
    fi

    # Temperature drift
    update_temp

    # Sleep 1–2 minutes
    sleep "$(rand_interval)"

done