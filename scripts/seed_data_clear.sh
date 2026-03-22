#!/usr/bin/env bash
ADB="adb"   # or: adb -s <serial>

echo "[ClearSeeder] Starting cleanup of seeded data..."

# ======================================================
# 1) CONTACTS — Remove all local contacts
# ======================================================
echo "[ClearSeeder] Deleting contacts..."
$ADB shell content delete --uri content://contacts/contacts
$ADB shell content delete --uri content://raw_contacts
$ADB shell content delete --uri content://data

# ======================================================
# 2) SMS — Remove inbox, sent, drafts
# ======================================================
echo "[ClearSeeder] Deleting SMS..."
$ADB shell content delete --uri content://sms
$ADB shell content delete --uri content://mms-sms/conversations/

# ======================================================
# 3) CALL LOG — Clear entire call history
# ======================================================
echo "[ClearSeeder] Deleting call logs..."
$ADB shell content delete --uri content://call_log/calls

# ======================================================
# 4) PHOTOS — Remove seeded photos from camera/DCIM
# ======================================================
echo "[ClearSeeder] Removing photos..."
$ADB shell rm -rf /sdcard/DCIM/Camera/*
$ADB shell rm -rf /sdcard/Pictures/*

# ======================================================
# 5) DOWNLOADS & DOCUMENTS — Remove clutter
# ======================================================
echo "[ClearSeeder] Removing files..."
$ADB shell rm -f /sdcard/Download/*
$ADB shell rm -f /sdcard/Documents/*
$ADB shell rm -f /sdcard/DCIM/*thumbnail*

# ======================================================
# 6) BROWSER HISTORY — Clear Chrome data
# ======================================================
echo "[ClearSeeder] Clearing Chrome history/cache..."
$ADB shell pm clear com.android.chrome >/dev/null 2>&1

# If using WebView browser instead:
$ADB shell pm clear com.android.browser >/dev/null 2>&1

# ======================================================
# 7) NOTIFICATIONS — Clear all
# ======================================================
echo "[ClearSeeder] Dismissing notifications..."
$ADB shell cmd notification cancel_all

# ======================================================
# 8) RECENTS SCREEN — Close all recent apps
# ======================================================
echo "[ClearSeeder] Clearing recents..."
$ADB shell input keyevent 187
sleep 1
$ADB shell input keyevent 111   # KEYCODE_ESCAPE (dismiss)

# ======================================================
# 9) USAGE STATS — Reset last 24h usage
# ======================================================
echo "[ClearSeeder] Resetting usage stats..."
$ADB shell pm reset-permissions >/dev/null 2>&1
$ADB shell rm -rf /data/system/usagestats/*

# ======================================================
# 10) CLEAN TEMP FOLDERS
# ======================================================
echo "[ClearSeeder] Removing temp seeder folders..."
rm -rf sample_photos

echo "[ClearSeeder] ✅ All seeded user data cleared."