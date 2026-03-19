#!/system/bin/sh
# ======================================================
#  FULL DEVICE SPOOF & TELEPHONY/WIFI/BATTERY FIX SCRIPT
#  For ReDroid + Magisk resetprop systemless environment
# ======================================================

# ---- Locate resetprop from your Magisk installation ----
alias rp='/system/etc/init/magisk/magisk resetprop'

# ======================================================
#  1. SAMSUNG A51 IDENTITY SPOOFING
# ======================================================

FPR="samsung/a51xx/a51:12/SP1A.210812.016/A515FXXU8DWB1:user/release-keys"
BRAND="samsung"
MFR="Samsung"
MODEL="SM-A515F"
DEVICE="a51"
NAME="a51xx"

# Top-level identity
rp ro.build.type user
rp ro.build.tags release-keys
rp ro.kernel.qemu 0
rp ro.product.brand "$BRAND"
rp ro.product.manufacturer "$MFR"
rp ro.product.model "$MODEL"
rp ro.product.device "$DEVICE"
rp ro.product.name "$NAME"
rp ro.build.fingerprint "$FPR"
rp ro.build.description "a51xx-user 12 SP1A.210812.016 release-keys"
rp ro.build.display.id "a51xx-user 12 SP1A.210812.016 release-keys"
rp ro.build.flavor "a51xx-user"
rp ro.build.product "$DEVICE"

# Partition-scoped identity
for S in system vendor product odm system_ext; do
  rp "ro.product.${S}.brand" "$BRAND"
  rp "ro.product.${S}.manufacturer" "$MFR"
  rp "ro.product.${S}.model" "$MODEL"
  rp "ro.product.${S}.device" "$DEVICE"
  rp "ro.product.${S}.name" "$NAME"

  rp "ro.${S}.build.fingerprint" "$FPR"
  rp "ro.${S}.build.type" user
  rp "ro.${S}.build.tags" release-keys
done

# DLKM partitions (sometimes visible)
for S in vendor_dlkm; do
  rp "ro.${S}.build.fingerprint" "$FPR"
  rp "ro.${S}.build.type" user
  rp "ro.${S}.build.tags" release-keys
  rp "ro.product.${S}.device" "$DEVICE"
  rp "ro.product.${S}.name" "$NAME"
done

# ======================================================
#  2. IMEI, SERIAL, MODEM, RADIO SPOOFING
# ======================================================

# IMEI (fake but realistic)
rp persist.radio.imei "354987654321012"
rp persist.radio.meid "A00000B1C2D3E4"

# Serial numbers
rp ro.boot.serialno "R58M123ABC"
rp ro.serialno "R58M123ABC"

# Fake baseband & radio info
rp gsm.version.baseband "A515FXXU8DWB1"
rp persist.radio.multisim.config "none"

# ======================================================
#  3. FULL SIM CARD SPOOFING
# ======================================================

# SIM present
rp gsm.sim.state "READY"

# Carrier identifiers (Viettel example)
rp gsm.operator.numeric "45204"
rp gsm.operator.alpha "Viettel"
rp gsm.operator.iso-country "vn"

rp gsm.sim.operator.numeric "45204"
rp gsm.sim.operator.alpha "Viettel"
rp gsm.sim.operator.iso-country "vn"

# ICCID (SIM card serial)
rp ril.iccid.sim1 "8984048520401234567"

# Phone number (optional, must be E.164)
rp line1.number "+84981234567"

# Network capability presence
rp ro.telephony.default_network 9

# ======================================================
#  4. WIFI SPOOFING (hide ethernet)
# ======================================================

# Make Android believe Wi‑Fi exists
rp wifi.interface "wlan0"

# Realistic WiFi MAC
rp ro.boot.wifimacaddr "d8:31:34:ab:92:01"
rp persist.sys.wifi_mac "d8:31:34:ab:92:01"

# Region
rp wifi.supplicant_scan_interval 15

# ======================================================
#  5. BLUETOOTH SPOOFING
# ======================================================

rp ro.bt.bdaddr "22:33:44:55:66:77"
rp persist.service.bdroid.bdaddr "22:33:44:55:66:77"

# ======================================================
#  6. BATTERY SERVICE FIX (Removes “error reading battery”)
# ======================================================

# These must run via dumpsys *after boot* (service.d handles this timing)
dumpsys battery reset
dumpsys battery set level 83
dumpsys battery set status 3   # discharging
dumpsys battery set ac 0
dumpsys battery set usb 0
dumpsys battery set wireless 0
dumpsys battery set temp 305   # 30.5°C

# ======================================================
#  7. EXTRA HARDENING
# ======================================================

rp ro.config.low_ram false
rp persist.sys.locale "vi-VN"
rp persist.sys.timezone "Asia/Ho_Chi_Minh"

# End of script
exit 0