#!/bin/bash

SLEEP_TIME=200
LOG_FILE="/home/yusuffmiracc/codes/middleBashScripts/Entegre_sistem_izleme/system_daemon.log"

send_telegram() {
  local mesaj="$1"
  curl -s -X POST \
  "https://api.telegram.org/botID/sendMessage" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
  --data-urlencode "chat_id=1442893987" \
  --data-urlencode "text=$mesaj" \
  > /dev/null
}

log_write(){
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

create_archive(){
    local degisken=$(date +%Y-%m-%d)
    local arsivlenecek=$(find ./logs -mtime +7 -name "*.log")

    if [ -n "$arsivlenecek" ]; then

        #tar -czvf /tmp/logArchive_$degisken.tar.gz $arsivlenecek
        log_write "BAŞARILI: Eski loglar arşivlendi ve disk rahatlatıldı."
    else
        log_write "BİLGİ: Arşivlencek eski dosya bulunamadı"
    fi
}

check_ram(){
    local ram_total=$(free -m | awk '/^Mem:/ {print $2}')
    local ram_used=$(free -m | awk '/^Mem:/ {print $3}')

    local ram_parcent=$((($ram_used * 100) / $ram_total))
    log_write "INFO: Ram kullanımı: $ram_parcent"
    if [ "$ram_parcent" -gt 80 ]; then
        log_write "UYARI: Ram kritik düzeyde otomatik temizleme başlıyor"
        send_telegram "🚨 Sunucu Uyarısı: RAM kullanımı % ${ram_parcent} seviyesinde!"
    fi
}

check_disk(){
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    log_write "INFO: Kök Dizin (/) Disk Kullanımı: %$disk_usage"

    if [ "$disk_usage" -gt 80 ];then
        log_write "UYARI: Disk kullanımı %80'i aştı! Otonom müdahale başlatılıyor..."
        #create_archive
        send_telegram "🚨 Eski loglar arşivlendi sistemde yer açıldı"
    fi
}

check_cpu(){
    local a=$(top -bn1 | grep "Cpu(s)" | awk '{print int($8)}')
    local cpu_usage=$((100 - a))

    log_write "CPU doluluk oranı %$cpu_usage"
    if [ "$cpu_usage" -gt 80 ]; then
        log_write "UYARI: İşlem yükü çok fazla"
        send_telegram "🚨 Sunucu Uyarısı: CPU kullanımı %${cpu_usage} seviyesinde!"
    fi

}

check_auth_logs(){
    local failed_attemps=$(tail -n 100 /var/log/auth.log | grep "failure" | wc -l)

    if [ "$failed_attemps" -gt 3 ]; then
        log_write "UYARI: Şüpheli ssh etkinliği $failed_attemps adet hata tespit edildi"
        send_telegram "🚨 $failed_attemps adet hatalı giriş yapıldı"
    fi
}

while true
do

sleep "$SLEEP_TIME"
check_ram
check_disk
check_cpu
check_auth_logs

done
