#!/bin/bash

kontrol(){
    if [ $? -eq 0 ]; then
        echo "İşlem başarılı..."
    else
        echo "İşlem başarısız..."
    fi
}

listele(){
    read -p "Lütfen dizini giriniz: " degisken
    find "$degisken" -name "*.log" #-exec ls -l {} +
    kontrol
}

eski_loglari_bul(){
    read -p "Lütfen dizini giriniz: " degisken
    find "$degisken" -mtime +7 #-exec ls -lh {} \;
    kontrol
}

arsiv_olustur(){
    degisken=$(date +%Y-%m-%d)
    arsivlenecek=$(find ./logs -mtime +7 -name "*.log")
    if [ -z "$arsivlenecek" ]; then
        echo "Arşivlenecek eski log bulunmuyor"
    else
        tar -czvf archive/logArchive_$degisken.tar.gz $arsivlenecek
        kontrol
    fi
}

disk_kullanimi(){
    du -sh logs archive
}

eski_loglari_sil(){
    
    eski_loglar=$( find logs -type f -mtime +7 -name "*.log")
    if [ -z "$eski_loglar" ]; then
        echo "Silinecek dosya bulunamadı..."
    else
        echo "Silinecek dosyalar: $eski_loglar"
        read -p "Bulunan eski dosyalar silinsin mi: (e/h) " secim
        if [ "$secim" = e ]; then
            find /logs -type f -mtime +7 -name "*.log" -delete
            kontrol
        elif [ "$secim" = h ]; then
            echo "Silme işlemi iptal edildi..."
        fi
    fi
}

menu (){
    clear
    echo """
    ===============================
         LOG TEMİZLEME SİSTEMİ
    ===============================

    1) Logları listele
    2) Eski logları bul
    3) Arşiv oluştur
    4) Disk kullanımını göster
    5) Eski logları sil
    0) Çıkış

    ===============================
    """

}

while true
do
    menu
    read -p "Lütfen bir sayı giriniz: " giris

    case $giris in
    0)
        echo "Çıkış yapılıyor"
        sleep 0.5
        echo "..."
        sleep 0.5
        echo ".."
        sleep 0.5
        echo "."
        break
    ;;
    1)
        listele
    ;;
    2)
        eski_loglari_bul
    ;;
    3)
        arsiv_olustur
    ;;
    4)
        disk_kullanimi
    ;;
    5)
        eski_loglari_sil
    ;;

    esac
    read -p "Devam etmek için Enter..."
done