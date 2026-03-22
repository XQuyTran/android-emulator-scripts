#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"   # OR: ADB="adb -s <device>"

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
    curl -L -o "$OUT" "$URL"
}

install_apk() {
    local APK="$1"
    echo "[AutoInstall] Installing $APK..."
    $ADB install -r "$APK"
}

# ------------------------------------------------------------
# 1. Google Chrome
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.android.chrome?version=latest" \
  "chrome.apk"
install_apk "chrome.apk"

# ------------------------------------------------------------
# 2. Google Messages (SMS)
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.messaging?version=latest" \
  "messages.apk"
install_apk "messages.apk"

# ------------------------------------------------------------
# 3. Google Phone (Dialer)
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.dialer?version=latest" \
  "phone.apk"
install_apk "phone.apk"

# ------------------------------------------------------------
# 4. Simple Gallery (FOSS Gallery App)
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.simplemobiletools.gallery.pro?version=latest" \
  "simple_gallery.apk"
install_apk "simple_gallery.apk"

# ------------------------------------------------------------
# 5. Files by Google
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.apps.nbu.files?version=latest" \
  "files.apk"
install_apk "files.apk"

# ------------------------------------------------------------
# 6. YouTube
# ------------------------------------------------------------
download_apk \
  "https://d.apkpure.com/b/APK/com.google.android.youtube?version=latest" \
  "youtube.apk"
install_apk "youtube.apk"

# ------------------------------------------------------------
# OPTIONAL: Facebook, TikTok, Instagram
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
