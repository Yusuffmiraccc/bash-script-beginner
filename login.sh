#!/bin/bash

kullanici_adi="admin"
kullanici_sifre="12345"
deneme_hakki=0

while [ true ]
do
    echo "Kullanıcı Adınızı Giriniz: "
    read girilen_kullanici

    echo "Şifrenizi Giriniz: "
    read -s girilen_sifre

    if [ "$girilen_kullanici" == "$kullanici_adi" ]&&
    [ "$girilen_sifre" == "$kullanici_sifre" ]
    then
        echo "Giriş başarılı"
        echo "[$(date)] Kullanıcı: $girilen_kullanici -> BAŞARILI" >> login.log
        break
    
    else
        echo "Kullanıcı adı veya şifre hatalı"
        deneme_hakki=$((deneme_hakki+1))
        echo "[$(date)] Kullanıcı: $girilen_kullanici -> HATALI" >> login.log
        
        if [ $deneme_hakki -eq 3 ]
        then
            echo "Hesap kitlendi"
            echo "[$(date)] Kullanıcı: $girilen_kullanici -> KİLİTLENDİ" >> login.log
            exit 1
        fi
    fi
    
done
