#!/system/bin/sh
# ======================================================
# Redmi Pad SE (Wi‑Fi Tablet) – ReDroid‑safe identity
# ======================================================

alias rp='/system/etc/init/magisk/magisk resetprop'

# ------------------------------------------------------
# Device classification
# ------------------------------------------------------
rp ro.build.characteristics tablet

# ------------------------------------------------------
# OEM / Product identity
# ------------------------------------------------------
rp ro.product.brand Xiaomi
rp ro.product.manufacturer Xiaomi
rp ro.product.model "Redmi Pad SE"
rp ro.product.device redmi_pad_se
rp ro.product.name redmi_pad_se
rp ro.product.odm.device redmi_pad_se
rp ro.product.odm.name redmi_pad_se
rp ro.product.product.device redmi_pad_se
rp ro.product.product.name redmi_pad_se
rp ro.product.system.device redmi_pad_se
rp ro.product.system.name redmi_pad_se
rp ro.product.system_ext.device redmi_pad_se
rp ro.product.system_ext.name redmi_pad_se
rp ro.product.vendor.device redmi_pad_se
rp ro.product.vendor.name redmi_pad_se
rp ro.product.vendor_dlkm.device redmi_pad_se
rp ro.product.vendor_dlkm.name redmi_pad_se

# ------------------------------------------------------
# Build identity
# ------------------------------------------------------
rp ro.build.type user
rp ro.build.tags release-keys
rp ro.build.flavor redmi_pad_se_wifi-user
rp ro.build.description "redmi_pad_se_wifi-user 13 release-keys"
rp ro.build.display.id "redmi_pad_se_wifi-user 13 release-keys"

rp ro.build.fingerprint \
"Xiaomi/redmi_pad_se_wifi/redmi_pad_se:13/TQ3A.230805.001/user/release-keys"

# ------------------------------------------------------
# Partition consistency
# ------------------------------------------------------
for S in system vendor product odm system_ext vendor_dlkm; do
  rp "ro.${S}.build.type" user
  rp "ro.${S}.build.tags" release-keys
  rp "ro.${S}.build.fingerprint" \
  "Xiaomi/redmi_pad_se_wifi/redmi_pad_se:13/TQ3A.230805.001/user/release-keys"
done

# ------------------------------------------------------
# Disable telephony (Wi‑Fi tablet)
# ------------------------------------------------------
rp ro.radio.noril yes
rp ro.telephony.default_network 0
rp persist.radio.no_sim_notification 1

# ------------------------------------------------------
# Wi‑Fi focus
# ------------------------------------------------------
rp wifi.interface wlan0
rp ro.wifi.country VN
rp persist.wifi.country VN

# ------------------------------------------------------
# Optional Xiaomi tablet flavor hints (harmless)
# ------------------------------------------------------
rp ro.miui.ui.version.name "MIUI"
rp ro.miui.ui.version.code 14
rp ro.miui.build.region VN

# ------------------------------------------------------
# General realism
# ------------------------------------------------------
rp ro.kernel.qemu 0
rp ro.config.low_ram false
rp persist.sys.locale vi-VN
rp persist.sys.timezone Asia/Ho_Chi_Minh

exit 0