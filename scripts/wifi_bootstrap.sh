#!/system/bin/sh
#
# Wi‑Fi bootstrap for ReDroid (Wi‑Fi–only tablet profile)
# Safe for AOSP / Android 13 / Redmi Pad SE posture
#

echo "[WiFiBootstrap] Starting Wi-Fi bootstrap …"

# --------------------------------------------------
# 1. Basic system state
# --------------------------------------------------

# Ensure airplane mode is OFF
settings put global airplane_mode_on 0
am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false >/dev/null 2>&1

# Enable Wi‑Fi subsystem
svc wifi enable
settings put global wifi_on 1

# Try to disable Ethernet hints (best‑effort)
settings put global ethernet_on 0 >/dev/null 2>&1 || true

sleep 2

# --------------------------------------------------
# 2. Remove stale / broken networks (optional cleanup)
# --------------------------------------------------

# List and forget existing networks (best‑effort)
cmd wifi list-networks | grep networkId | awk '{print $2}' | while read -r ID; do
  cmd wifi forget-network "$ID" >/dev/null 2>&1
done

# --------------------------------------------------
# 3. Inject a known Wi‑Fi network (mock connected SSID)
# --------------------------------------------------

SSID="Home_WiFi_5G"
PSK="testpassword123"

echo "[WiFiBootstrap] Adding Wi-Fi network: $SSID"

cmd wifi add-network "{
  \"ssid\": \"\\\"$SSID\\\"\",
  \"securityParams\": \"WPA2_PSK\",
  \"preSharedKey\": \"\\\"$PSK\\\"\"
}"

# Enable and connect to the first network (ID 0 is typical after cleanup)
cmd wifi enable-network 0 true

sleep 2

# --------------------------------------------------
# 4. Force connectivity refresh
# --------------------------------------------------

svc data disable >/dev/null 2>&1 || true
svc data enable  >/dev/null 2>&1 || true

# --------------------------------------------------
# 5. Status output (for debugging)
# --------------------------------------------------

echo "[WiFiBootstrap] Connectivity state:"
dumpsys connectivity | grep -A5 WIFI

echo "[WiFiBootstrap] Wi-Fi info:"
dumpsys wifi | grep -E "SSID|state|mNetworkInfo" | head -n 10

echo "[WiFiBootstrap] Done."