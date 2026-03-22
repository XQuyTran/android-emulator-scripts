#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"

echo "[ClearSeeder] Starting cleanup..."

# ======================================================
# ✅ CONTACTS (modern providers)
# ======================================================
echo "[ClearSeeder] Removing contacts..."

# Delete all data rows (names, numbers, emails…)
$ADB shell content delete --uri content://com.android.contacts/data

# Delete all raw contacts (individual entries)
$ADB shell content delete --uri content://com.android.contacts/raw_contacts

# Delete contact aggregates (display entries)
$ADB shell content delete --uri content://com.android.contacts/contacts


# ======================================================
# ✅ SMS (modern AOSP provider still supports this)
# ======================================================
echo "[ClearSeeder] Removing SMS..."
$ADB shell content delete --uri content://sms
$ADB shell content delete --uri content://mms-sms/conversations/


# ======================================================
# ✅ CALL LOGS
# ======================================================
echo "[ClearSeeder] Removing call logs..."
$ADB shell content delete --uri content://call_log/calls


# ======================================================
# ✅ PHOTOS (DCIM, Pictures, Screenshots, etc.)
# ======================================================
echo "[ClearSeeder] Removing photos..."
$ADB shell rm -rf /sdcard/DCIM/Camera/*
$ADB shell rm -rf /sdcard/Pictures/*
$ADB shell rm -rf /sdcard/Screenshots/*


# ======================================================
# ✅ FILESYSTEM CLUTTER
# ======================================================
echo "[ClearSeeder] Cleaning file clutter..."
$ADB shell rm -f /sdcard/Download/*
$ADB shell rm -f /sdcard/Documents/*
$ADB shell rm -f /sdcard/DCIM/*thumbnail*


# ======================================================
# ✅ BROWSER HISTORY (Chrome / WebView)
# ======================================================
echo "[ClearSeeder] Clearing browser data..."
$ADB shell pm clear com.android.chrome >/dev/null 2>&1
$ADB shell pm clear com.android.browser >/dev/null 2>&1 || true


# ======================================================
# ✅ NOTIFICATIONS
# ======================================================
echo "[ClearSeeder] Clearing notifications..."
$ADB shell cmd notification post_dismiss_all


# ======================================================
# ✅ RECENT APPS
# ======================================================
echo "[ClearSeeder] Clearing recents..."
$ADB shell input keyevent 187
sleep 1
$ADB shell input keyevent 111


# ======================================================
# ✅ USAGE STATS
# ======================================================
echo "[ClearSeeder] Clearing app usage stats..."
$ADB shell rm -rf /data/system/usagestats/* 2>/dev/null || true


# ======================================================
# ✅ TEMP FOLDERS
# ======================================================
echo "[ClearSeeder] Removing temp seed folders..."
rm -rf sample_photos


echo "[ClearSeeder] All seeded data cleared successfully!"