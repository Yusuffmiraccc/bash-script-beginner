#!/bin/bash

LOG_FILE="/home/yusuffmiracc/codes/middleBashScripts/otonom_ag_bekcisi/SERVİCE_MONITOR_LOGS.log"

log_write(){
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

init_baseline(){
    if [ ! -f "baseline.txt" ]; then
    ss -ltn | awk 'NR>1 {print $4}' | awk -F':' '{print $NF}' | sort -u > baseline.txt
        log_write "Referans dosyası oluşturuldu."
        exit 0
    fi
}

take_snapshot(){
    ss -ltn | awk 'NR>1 {print $4}' | awk -F':' '{print $NF}' | sort -u > current_ports.txt
}

compare_ports(){
    local new_ports=$(comm -13 baseline.txt current_ports.txt)
    local closed_ports=$(comm -23 baseline.txt current_ports.txt)

    if [ -n "$new_ports" ]; then
        log_write "UYARI: Sisteme yeni giriş yapan port tespit edildi: $new_ports"
    fi
    if [ -n "$closed_ports" ]; then
        log_write "UYARI: Sisteme kapatılan portlar tespit edildi: $closed_ports"
    fi
}

init_baseline
take_snapshot
compare_ports

rm -f current_ports.txt