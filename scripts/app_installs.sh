#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0"

echo "[AutoInstall] Creating download folder..."
mkdir -p apk_downloads
cd apk_downloads

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
# 1. GOOGLE CHROME
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.android.chrome?version=latest" \
  "chrome.apk"
install_apk "chrome.apk"

# ------------------------------------------------------------
# 2. GOOGLE MESSAGES (SMS)
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.messaging?version=latest" \
  "messages.apk"
install_apk "messages.apk"

# ------------------------------------------------------------
# 3. GOOGLE PHONE (Dialer)
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.dialer?version=latest" \
  "phone.apk"
install_apk "phone.apk"

# ------------------------------------------------------------
# 4. SIMPLE GALLERY (FOSS)
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.simplemobiletools.gallery.pro?version=latest" \
  "simple_gallery.apk"
install_apk "simple_gallery.apk"

# ------------------------------------------------------------
# 5. FILES BY GOOGLE
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.nbu.files?version=latest" \
  "files.apk"
install_apk "files.apk"

# ------------------------------------------------------------
# 6. YOUTUBE
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.youtube?version=latest" \
  "youtube.apk"
install_apk "youtube.apk"

# ------------------------------------------------------------
# OPTIONAL: Facebook, TikTok, Instagram
# (Uncomment the following blocks to install them)
# ------------------------------------------------------------

# TikTok
# download_apk \
#   "https://d.apkpure.com/b/APK/com.zhiliaoapp.musically?version=latest" \
#   "tiktok.apk"
# install_apk "tiktok.apk"

# Facebook
# download_apk \
#   "https://d.apkpure.com/b/APK/com.facebook.katana?version=latest" \
#   "facebook.apk"
# install_apk "facebook.apk"

# Instagram
# download_apk \
#   "https://d.apkpure.com/b/APK/com.instagram.android?version=latest" \
#   "instagram.apk"
# install_apk "instagram.apk"

echo "[AutoInstall] ✅ All apps installed successfully."