#!/bin/bash
LOG_FILE="system.log"

log_yaz(){
    mesaj="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $mesaj" >> "$LOG_FILE"
}

while true
do

echo """
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       SİSTEM YÖNETİM PANELİ       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1) Aktif kullanicilari goster
2) Aktif kullanici sayisi
3) Disk kullanimini goster
4) Bulundugum dizin
5) Son 10 log
6) Tarih ve saat
0) Cikis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""
    read -p "lütfen bir değer giriniz: " secim
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    case $secim in
        0)
            echo "Çıkış yapılıyor"
            echo "  . "
            sleep 0.5
            echo " ..."
            sleep 0.5
            echo "....."
            sleep 0.1
            break
            ;;
        1)
            kullanicilar=$(w)
            echo "Aktif kullanıcılar: $kullanicilar"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            log_yaz "Aktif kullanıcılar: $kullanicilar"
            ;;
        2)
            kullanici_sayisi=$(w | tail -n 3 | wc -l)
            echo "Aktif kullanıcı sayısı: $kullanici_sayisi"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            log_yaz "Aktif kullanıcı sayısı: $kullanici_sayisi"
            ;;
        3) 
            disk_kullanimi=$(df -h | awk '{print $1, $5}')
            echo "Disk kullanımı: $disk_kullanimi"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            log_yaz "Disk kullanımı: $disk_kullanimi"
            ;;
        4)
            dizinim=$(pwd)
            echo "Bulunduğum dizin: $dizinim"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            log_yaz "Bulunduğum dizin: $dizinim"
            ;;
        5)
            echo "Son 10 log: "
            ;;
        6)
            tarih=$(date "+%d-%m-%Y %H:%M:%S")   
            echo "Tarih ve saat: $tarih"
            echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            log_yaz "Tarih ve saat: $tarih"
            ;;
       
        *)
            echo "Geçersiz seçim!!"
            log_yaz "Geçersiz seçim!!"
            ;;
    esac
done