#!/usr/bin/env bash

ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0"

echo "[AutoInstall] Creating download folder..."
mkdir -p apk_downloads
cd apk_downloads || exit 1

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------
download_apk() {
  local URL="$1"
  local OUT="$2"
  echo "[AutoInstall] Downloading $OUT ..."
  wget --header="User-Agent: $UA" -O "$OUT" "$URL"
}

install_apk() {
  local APK="$1"
  echo "[AutoInstall] Installing $APK..."
  $ADB install -r "$APK"
}

# ------------------------------------------------------------
# Browser / Reading
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.android.chrome?version=latest" \
  "chrome.apk"
install_apk "chrome.apk"

# ------------------------------------------------------------
# Media / Entertainment
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.youtube?version=latest" \
  "youtube.apk"
install_apk "youtube.apk"

download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.youtube.music?version=latest" \
  "ytmusic.apk"
install_apk "ytmusic.apk"

# ------------------------------------------------------------
# Productivity
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.docs.editors.docs?version=latest" \
  "docs.apk"
install_apk "docs.apk"

download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.calendar?version=latest" \
  "calendar.apk"
install_apk "calendar.apk"

# ------------------------------------------------------------
# File & Media Management
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.nbu.files?version=latest" \
  "files.apk"
install_apk "files.apk"

# ------------------------------------------------------------
# Messaging (Wi‑Fi acceptable for tablet)
# ------------------------------------------------------------

# ------------------------------------------------------------
# OPTIONAL Social / Casual Apps (tablet‑appropriate)
# Uncomment only if you want them
# ------------------------------------------------------------

# download_apk \
#   "https://d.apkpure.com/b/APK/org.telegram.messenger?version=latest" \
#   "telegram.apk"
# install_apk "telegram.apk"

# download_apk \
#   "https://d.apkpure.com/b/APK/com.instagram.android?version=latest" \
#   "instagram.apk"
# install_apk "instagram.apk"

# download_apk \
#   "https://d.apkpure.com/b/APK/com.facebook.katana?version=latest" \
#   "facebook.apk"
# install_apk "facebook.apk"

echo "[AutoInstall] ✅ Tablet apps installed successfully."
