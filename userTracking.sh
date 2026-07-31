#!/bin/bash

STATE_FILE="last_users.txt"
LOG_FILE="user_system.log"

send_telegram() {
  mesaj=$1
  curl -s -X POST \
  "https://api.telegram.org/botID/sendMessage" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
  --data-urlencode "chat_id= id" \
  --data-urlencode "text=$mesaj" \
  > /dev/null
}

log_yaz(){
    mesaj="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $mesaj" >> "$LOG_FILE"

}
echo "===== KULLANICI İZLEME ====="

if [ -f $STATE_FILE ]
then
    eski=$(cat "$STATE_FILE")
else
    eski=0
fi

users=$(w)
send_telegram "Aktif kullanıcılar: $users"

degisken=$( w | tail -n +3 | wc -l )
echo "Aktif kullanıcı sayısı = $degisken"
log_yaz "Aktif kullanıcı: $degisken"
send_telegram "Aktif kullanıcı sayısı: $degisken"

if [ "$eski" != "$degisken" ]
then
    send_telegram "Kullanıcı sayısı degisti"
    echo "$degisken" > "$STATE-FILE"
fi

if [ "$degisken" -gt 3 ]
then 
    echo "Durum: UYARI" 
    log_yaz "[WARNİNG] Kullanıcı sayısı 3'ü geçti "
    send_telegram "UYARI KULLANICI SAYISI SINIRIN ÜZERİNDE"

else 
    echo "Durum: NORMAL"
fi

echo "===== KULLANICI İZLEME SÜRECİ BİTTİ ====="
