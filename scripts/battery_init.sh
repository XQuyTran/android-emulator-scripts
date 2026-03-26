#!/system/bin/sh
# Initialize battery to a realistic state

sleep 5

dumpsys battery reset

# Initial battery % (70–95 looks natural)
dumpsys battery set level $(( 70 + RANDOM % 26 ))

# Start in discharging state
dumpsys battery set status 3
dumpsys battery set ac 0
dumpsys battery set usb 0

# Moderate temperature (in tenths of °C)
dumpsys battery set temp 310    # 31°C

echo "[BatterySim] Initialized."