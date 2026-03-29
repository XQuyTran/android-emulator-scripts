#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"

echo "[Seeder] Starting tablet-style user data seeding..."

# ======================================================
# 1) MEDIA FILES (DCIM / Pictures)
# ======================================================
echo "[Seeder] Adding media files..."

mkdir -p tablet_media

wget -qO tablet_media/img1.jpg https://picsum.photos/1600/1200
wget -qO tablet_media/img2.jpg https://picsum.photos/1920/1080
wget -qO tablet_media/img3.jpg https://picsum.photos/1280/800
wget -qO tablet_media/img4.jpg https://picsum.photos/2560/1600
wget -qO tablet_media/img5.jpg https://picsum.photos/1024/1024

$ADB shell mkdir -p /sdcard/DCIM/Camera
$ADB shell mkdir -p /sdcard/Pictures

$ADB push tablet_media/img1.jpg /sdcard/DCIM/Camera/
$ADB push tablet_media/img2.jpg /sdcard/DCIM/Camera/
$ADB push tablet_media/img3.jpg /sdcard/Pictures/
$ADB push tablet_media/img4.jpg /sdcard/Pictures/
$ADB push tablet_media/img5.jpg /sdcard/Pictures/

# ======================================================
# 2) FILESYSTEM REALISM (Documents / Downloads)
# ======================================================
echo "[Seeder] Adding tablet documents..."

$ADB shell mkdir -p /sdcard/Download
$ADB shell mkdir -p /sdcard/Documents

$ADB shell 'echo "Meeting notes and reminders" > /sdcard/Documents/notes.txt'
$ADB shell 'echo "installation_complete=true" > /sdcard/Download/status.log'

# ======================================================
# 3) BROWSER HISTORY (Tablet style)
# ======================================================
echo "[Seeder] Seeding browser history..."

BROWSE_URLS=(
  "https://www.google.com"
  "https://wikipedia.org"
  "https://youtube.com"
  "https://news.google.com"
  "https://vnexpress.net"
)

for url in "${BROWSE_URLS[@]}"; do
  $ADB shell am start -a android.intent.action.VIEW -d "$url"
  sleep 3
done

# ======================================================
# 4) APP USAGE (Tablet behavior)
# ======================================================
echo "[Seeder] Generating app usage..."

$ADB shell monkey -p com.android.chrome 6
sleep 1
$ADB shell monkey -p com.google.android.youtube 6
sleep 1
$ADB shell monkey -p com.simplemobiletools.gallery.pro 4
sleep 1
$ADB shell monkey -p com.google.android.apps.nbu.files 3
sleep 1
$ADB shell monkey -p com.android.settings 2

# ======================================================
# 5) NOTIFICATIONS (Non-SMS, tablet-appropriate)
# ======================================================
echo "[Seeder] Posting system notifications..."

$ADB shell cmd notification post -t "System Update" tablet1 \
  "Your system is up to date."

$ADB shell cmd notification post -t "Download complete" tablet2 \
  "5 files downloaded successfully."

# ======================================================
# 6) RECENTS STACK
# ======================================================
echo "[Seeder] Adding recents..."

$ADB shell am start com.android.chrome/com.google.android.apps.chrome.Main
sleep 1
$ADB shell am start com.google.android.youtube/com.google.android.apps.youtube.app.watchwhile.WatchWhileActivity
sleep 1
$ADB shell input keyevent 3

echo "[Seeder] ✅ Tablet user data seeded successfully."
