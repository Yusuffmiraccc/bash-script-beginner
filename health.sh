#!/bin/bash
#telegram bot
send_telegram() {
  mesaj=$1
  curl -s -X POST \
  "https://api.telegram.org/botID/sendMessage" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
  --data-urlencode "chat_id=" \
  --data-urlencode "text=$mesaj" \ 
  > /dev/null
}

#LOG_FİLE="system.log"

log_yaz() {
    mesaj1="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $mesaj" >> "$system.log"
}

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

echo "==== SİSTEM DURUMU ===="

disk=$(df -h | grep " /$" | awk '{print $5}')
echo -e "${YELLOW}Disk Kullanımı= $disk${NC}"
log_yaz "Disk Kullanımı: $disk%"

ram=$(free -m | grep Mem | awk '{print $2, $3, $4}')
echo -e "${YELLOW}RAM Kullanımı= $ram${NC}"
log_yaz "Ram Kullanımı: $ram%"

cpu=$(uptime | awk -F'load average: ' '{print $2}' | cut -d',' -f1)
echo -e "${YELLOW}CPU Kullanımı= $cpu${NC}"
log_yaz "CPU Kullanımı: $cpu%"

upt=$(uptime -p)
echo -e "${GREEN}Sistem Açık Kalma Süresi= $upt${NC}"
log_yaz "Uptime Kullanımı: $uptime%"

disk_num=$(echo $disk | tr -d '%')

if [ $disk_num -gt 80 ]
then

    mesaj="UYARI! Disk kullanimi %$disk_num seviyesine ulasti"

    echo -e "${RED}$mesaj${NC}"
    log_yaz "$mesaj1"
    send_telegram "$mesaj"

else

    echo -e "${GREEN}Disk durumu normal${NC}"
    log_yaz "$mesaj1"

fi

echo "Uptime: $upt"

send_telegram "Sistem kontrol scripti test mesajı"
