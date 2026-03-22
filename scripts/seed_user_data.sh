#!/usr/bin/env bash
ADB_TARGET="${ADB_TARGET:-127.0.0.1:5555}"
ADB="adb -s $ADB_TARGET"

add_contact() {
  local NAME="$1"
  local PHONE="$2"

  # Create local raw contact (null account_type + null account_name = "Local Phone")
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
      --bind data2:i:2  > /dev/null
}

echo "[Seeder] Starting realistic user data seeding..."

# ======================================================
# 1) CONTACTS — Diverse, realistic international names
# ======================================================

echo "[Seeder] Creating diverse international contacts..."

FIRST_NAMES=("John" "Maria" "Li" "Sara" "David" "Aisha" "Ravi" "Hiroshi" "Elena" \
             "Chen" "Paul" "Fatima" "Lucas" "Mina" "Anand" "Kim" "Diego" "Emma" \
             "Sofia" "Omar" "Nina" "Victor" "Alex" "Isabella")

LAST_NAMES=("Smith" "Garcia" "Kim" "Zhang" "Khan" "Singh" "Yamada" "Ng" "Taylor" \
            "Hernandez" "Park" "Ali" "Chen" "Costa" "Lee" "Das" "Martinez" \
            "Brown" "Silva" "Johnson" "Williams" "Lopez" "Kimura")

PHONE_PREFIXES=("+84" "+1" "+44" "+65" "+49" "+81" "+34" "+852" "+61" "+971" "+33" "+82")

for i in $(seq 1 25); do
  FIRST=${FIRST_NAMES[$RANDOM % ${#FIRST_NAMES[@]}]}
  LAST=${LAST_NAMES[$RANDOM % ${#LAST_NAMES[@]}]}
  NAME="$FIRST\ $LAST"

  PREFIX=${PHONE_PREFIXES[$RANDOM % ${#PHONE_PREFIXES[@]}]}
  NUMBER="$PREFIX$((10000000 + RANDOM % 89999999))"

  add_contact "$NAME" "$NUMBER"
done

# ======================================================
# 2) SMS — Inbox + Sent messages
# ======================================================

echo "[Seeder] Creating SMS threads..."

$ADB shell content insert --uri content://sms/inbox \
      --bind address:s:"Viettel" \
      --bind body:s:"Your\ data\ pack\ has\ been\ renewed\ successfully." \
      --bind date:l:`date +%s`000

$ADB shell content insert --uri content://sms/inbox \
      --bind address:s:"Shopee" \
      --bind body:s:"Your\ delivery\ will\ arrive\ today\ between\ 2-6\ PM." \
      --bind date:l:`date +%s`000

$ADB shell content insert --uri content://sms/sent \
      --bind address:s:"+84981234567" \
      --bind body:s:"I'll\ call\ you\ later." \
      --bind date:l:`date +%s`000

# ======================================================
# 3) CALL LOGS — Random real-looking call history
# ======================================================

echo "[Seeder] Creating call logs..."

for i in $(seq 1 15); do
  NUM="09$((10000000 + RANDOM % 89999999))"
  TYPE=$((1 + RANDOM % 3))   # 1=incoming, 2=outgoing, 3=missed
  DUR=$((RANDOM % 300))      # duration in seconds

  $ADB shell content insert --uri content://call_log/calls \
        --bind number:s:"$NUM" \
        --bind type:i:"$TYPE" \
        --bind duration:i:"$DUR"
done

# ======================================================
# 4) PHOTOS — Populate gallery with real-looking content
# ======================================================

echo "[Seeder] Adding sample photos..."

mkdir -p sample_photos
curl -s -o sample_photos/pic1.jpg https://picsum.photos/720/1280
curl -s -o sample_photos/pic2.jpg https://picsum.photos/720/1277
curl -s -o sample_photos/pic3.jpg https://picsum.photos/720/1283
curl -s -o sample_photos/pic4.jpg https://picsum.photos/1080/720
curl -s -o sample_photos/pic5.jpg https://picsum.photos/1920/1080

$ADB shell mkdir -p /sdcard/DCIM/Camera/
$ADB push sample_photos /sdcard/DCIM/Camera/

# ======================================================
# 5) BROWSER HISTORY — Open several sites to seed history
# ======================================================

echo "[Seeder] Seeding browser history..."

WEBSITES=(
  "https://www.google.com"
  "https://vnexpress.net"
  "https://youtube.com"
  "https://facebook.com"
  "https://stackoverflow.com"
)

for site in "${WEBSITES[@]}"; do
  $ADB shell am start -a android.intent.action.VIEW -d "$site"
  sleep 3
done

# ======================================================
# 6) APP USAGE — Using monkey to simulate human behavior
# ======================================================

echo "[Seeder] Generating app usage patterns..."

$ADB shell monkey -p com.android.settings 3
sleep 1
$ADB shell monkey -p com.android.chrome 5
sleep 1
$ADB shell monkey -p com.google.android.youtube 5
sleep 1
$ADB shell monkey -p com.android.vending 3

# ======================================================
# 7) NOTIFICATION SEEDING
# ======================================================

echo "[Seeder] Posting mock notifications..."

$ADB shell cmd notification post -t "Backup complete" tag1 "Your backup finished successfully."
$ADB shell cmd notification post -t "New message" tag2 "Reminder: Meeting at 3 PM."

# ======================================================
# 8) REALISTIC FILESYSTEM CLUTTER
# ======================================================

echo "[Seeder] Creating realistic file clutter..."

$ADB shell mkdir -p /sdcard/Download/
$ADB shell mkdir -p /sdcard/Documents/

$ADB shell 'echo "Weekly notes: shopping list, reminders..." > /sdcard/Documents/notes.txt'
$ADB shell 'echo "System log placeholder" > /sdcard/Download/sys_log.txt'

# ======================================================
# 9) RECENT APP SWITCHING
# ======================================================

echo "[Seeder] Simulating recent app switching..."

$ADB shell am start com.android.settings/.Settings
sleep 1
$ADB shell input keyevent 187     # app switcher
sleep 1
$ADB shell input keyevent 3       # home
