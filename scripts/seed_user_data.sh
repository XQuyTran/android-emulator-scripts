#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"   # or: adb -s <serial>

echo "[Seeder] Starting realistic user data seeding..."

# ======================================================
# HELPER: Add contact (local raw_contact, no Google)
# ======================================================
add_contact() {
  local NAME="$1"
  local PHONE="$2"

  # Create a local raw_contact entry
  RAW_ID=$($ADB shell content insert \
      --uri content://com.android.contacts/raw_contacts \
      --bind account_type:s:NULL \
      --bind account_name:s:NULL | awk -F= '/id/ {print $2}')

  # Add structured name
  $ADB shell content insert \
      --uri content://com.android.contacts/data \
      --bind raw_contact_id:i:"$RAW_ID" \
      --bind mimetype:s:"vnd.android.cursor.item/name" \
      --bind data2:s:"$NAME"

  # Add phone number
  $ADB shell content insert \
      --uri content://com.android.contacts/data \
      --bind raw_contact_id:i:"$RAW_ID" \
      --bind mimetype:s:"vnd.android.cursor.item/phone_v2" \
      --bind data1:s:"$PHONE" \
      --bind data2:i:2 >/dev/null
}

# ======================================================
# HELPER: Add SMS
# ======================================================
add_sms() {
  local BOX="$1"   # inbox / sent
  local FROM="$2"
  local BODY="$3"

  $ADB shell content insert --uri content://sms/"$BOX" \
      --bind address:s:"$FROM" \
      --bind body:s:"$BODY" \
      --bind date:l:$(( $(date +%s) * 1000 ))
}

# ======================================================
# 1) CONTACTS — Diverse global naming
# ======================================================

echo "[Seeder] Creating contacts..."

FIRST_NAMES=("John" "Maria" "Li" "Sara" "David" "Aisha" "Ravi" "Hiroshi" "Elena"
             "Chen" "Paul" "Fatima" "Lucas" "Mina" "Anand" "Kim" "Diego" "Emma"
             "Sofia" "Omar" "Nina" "Victor" "Alex" "Isabella")

LAST_NAMES=("Smith" "Garcia" "Kim" "Zhang" "Khan" "Singh" "Yamada" "Ng" "Taylor"
            "Hernandez" "Park" "Ali" "Chen" "Costa" "Lee" "Das" "Martinez"
            "Brown" "Silva" "Johnson" "Williams" "Lopez" "Kimura")

PREFIXES=("+84" "+1" "+44" "+65" "+49" "+81" "+34" "+852" "+61" "+971" "+33" "+82")

for i in $(seq 1 25); do
  FN=${FIRST_NAMES[$RANDOM % ${#FIRST_NAMES[@]}]}
  LN=${LAST_NAMES[$RANDOM % ${#LAST_NAMES[@]}]}
  NAME="$FN $LN"
  PREFIX=${PREFIXES[$RANDOM % ${#PREFIXES[@]}]}
  PHONE="$PREFIX$((10000000 + RANDOM % 89999999))"

  echo "[Seeder] Adding contact: $NAME ($PHONE)"
  add_contact "$NAME" "$PHONE"
done

# ======================================================
# 2) SMS — realistic threads
# ======================================================
echo "[Seeder] Adding SMS messages..."

add_sms inbox "Viettel" "Your data pack has been renewed successfully."
add_sms inbox "Shopee" "Your delivery will arrive today between 2-6 PM."
add_sms inbox "+12025550123" "Reminder: Your appointment is scheduled at 11 AM tomorrow."
add_sms sent "+84981234567" "I'll call you later."

# ======================================================
# 3) CALL LOG — realistic call history
# ======================================================

echo "[Seeder] Adding call logs..."

for i in $(seq 1 15); do
  NUM="09$((10000000 + RANDOM % 89999999))"
  TYPE=$((1 + RANDOM % 3))     # 1=incoming, 2=outgoing, 3=missed
  DUR=$((RANDOM % 240))        # seconds

  $ADB shell content insert --uri content://call_log/calls \
      --bind number:s:"$NUM" \
      --bind type:i:"$TYPE" \
      --bind duration:i:"$DUR"
done

# ======================================================
# 4) PHOTOS — populate DCIM
# ======================================================
echo "[Seeder] Adding sample photos to DCIM..."

mkdir -p sample_photos
curl -s -o sample_photos/p1.jpg https://picsum.photos/720/1280
curl -s -o sample_photos/p2.jpg https://picsum.photos/1280/720
curl -s -o sample_photos/p3.jpg https://picsum.photos/1080/1080
curl -s -o sample_photos/p4.jpg https://picsum.photos/800/600
curl -s -o sample_photos/p5.jpg https://picsum.photos/600/800

$ADB shell mkdir -p /sdcard/DCIM/Camera/
$ADB push sample_photos /sdcard/DCIM/Camera/

# ======================================================
# 5) BROWSER HISTORY — chrome visits
# ======================================================
echo "[Seeder] Opening browsing history seed URLs..."

BROWSE=(
  "https://www.google.com"
  "https://youtube.com"
  "https://vnexpress.net"
  "https://wikipedia.org"
  "https://facebook.com"
)

for url in "${BROWSE[@]}"; do
  $ADB shell am start -a android.intent.action.VIEW -d "$url"
  sleep 2
done

# ======================================================
# 6) USAGE / APP EVENTS — monkey interactions
# ======================================================
echo "[Seeder] Simulating app usage..."

$ADB shell monkey -p com.android.settings 3
sleep 1
$ADB shell monkey -p com.android.chrome 5
sleep 1
$ADB shell monkey -p com.google.android.youtube 4
sleep 1
$ADB shell monkey -p com.android.vending 3

# ======================================================
# 7) Notifications
# ======================================================
echo "[Seeder] Posting notifications..."

$ADB shell cmd notification post -t "Backup complete" tag1 "Your backup finished successfully."
$ADB shell cmd notification post -t "New message" tag2 "You have 2 unread emails."

# ======================================================
# 8) File Clutter
# ======================================================
echo "[Seeder] Adding clutter files..."

$ADB shell mkdir -p /sdcard/Download/
$ADB shell mkdir -p /sdcard/Documents/

$ADB shell 'echo "Shopping list: eggs, milk, coffee" > /sdcard/Documents/notes.txt'
$ADB shell 'echo "temp system log" > /sdcard/Download/log.txt'

# ======================================================
# 9) Recents
# ======================================================
echo "[Seeder] Adding recents..."

$ADB shell am start com.android.settings/.Settings
sleep 1
$ADB shell input keyevent 3

# ======================================================
# DONE
# ======================================================

echo "[Seeder] ✅ All realistic user data has been populated."
echo "[Seeder] ✅ You can view changes via scrcpy."