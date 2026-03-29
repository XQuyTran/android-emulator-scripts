#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"

echo "[ClearSeeder] Cleaning tablet user data..."

# ======================================================
# 1) MEDIA FILES
# ======================================================
echo "[ClearSeeder] Removing media files..."
$ADB shell rm -rf /sdcard/DCIM/Camera/*
$ADB shell rm -rf /sdcard/Pictures/*

# ======================================================
# 2) DOCUMENTS / DOWNLOADS
# ======================================================
echo "[ClearSeeder] Removing documents..."
$ADB shell rm -rf /sdcard/Download/*
$ADB shell rm -rf /sdcard/Documents/*

# ======================================================
# 3) BROWSER DATA
# ======================================================
echo "[ClearSeeder] Clearing browser data..."
$ADB shell pm clear com.android.chrome >/dev/null 2>&1

# ======================================================
# 4) APP USAGE STATS
# ======================================================
echo "[ClearSeeder] Clearing usage stats..."
$ADB shell rm -rf /data/system/usagestats/* 2>/dev/null || true

# ======================================================
# 5) NOTIFICATIONS
# ======================================================
echo "[ClearSeeder] Clearing notifications..."
$ADB shell service call statusbar 1 >/dev/null 2>&1 || true

# ======================================================
# 6) RECENTS
# ======================================================
echo "[ClearSeeder] Clearing recent apps..."
$ADB shell input keyevent 187
sleep 1
$ADB shell input keyevent 111

# ======================================================
# 7) TEMP FILES
# ======================================================
rm -rf tablet_media

echo "[ClearSeeder] ✅ Tablet data cleared."