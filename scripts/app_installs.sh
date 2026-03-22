#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"   # OR: ADB="adb -s <device>"

echo "[AutoInstall] Creating temp folder..."
mkdir -p apk_downloads
cd apk_downloads

# ------------------------------------------------------------
# HELPER FUNCTIONS
# ------------------------------------------------------------
download_apk() {
    local URL="$1"
    local OUT="$2"
    echo "[AutoInstall] Downloading $OUT ..."
    curl -L -o "$OUT" "$URL"
}

install_apk() {
    local FILE="$1"
    echo "[AutoInstall] Installing $FILE ..."
    $ADB install -r "$FILE"
}

# ------------------------------------------------------------
# 1. GOOGLE CHROME (standard APK)
# ------------------------------------------------------------
download_apk \
  "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=1002177" \
  "chrome.apk"
install_apk "chrome.apk"

# ------------------------------------------------------------
# 2. GOOGLE MESSAGES (SMS app)
# ------------------------------------------------------------
download_apk \
  "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=1001953" \
  "messages.apk"
install_apk "messages.apk"

# ------------------------------------------------------------
# 3. GOOGLE PHONE (Dialer)
# ------------------------------------------------------------
download_apk \
  "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=995794" \
  "phone.apk"
install_apk "phone.apk"

# ------------------------------------------------------------
# 4. SIMPLE GALLERY (FOSS)
# ------------------------------------------------------------
download_apk \
  "https://github.com/SimpleMobileTools/Simple-Gallery/releases/download/5.1.0/SimpleGalleryPro_5.1.0.apk" \
  "simple_gallery.apk"
install_apk "simple_gallery.apk"

# ------------------------------------------------------------
# 5. FILES BY GOOGLE
# ------------------------------------------------------------
download_apk \
  "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=982652" \
  "files.apk"
install_apk "files.apk"

# ------------------------------------------------------------
# 6. YOUTUBE
# ------------------------------------------------------------
download_apk \
  "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=1002074" \
  "youtube.apk"
install_apk "youtube.apk"

# ------------------------------------------------------------
# OPTIONAL: FACEBOOK, TIKTOK, INSTAGRAM (Uncomment to enable)
# ------------------------------------------------------------
download_apk \
  "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=991138" \
  "facebook.apk"
install_apk "facebook.apk"
#
# download_apk \
#   "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=1000372" \
#   "tiktok.apk"
# install_apk "tiktok.apk"
#
# download_apk \
#   "https://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=999411" \
#   "instagram.apk"
# install_apk "instagram.apk"

echo "[AutoInstall] ✅ All apps installed."