#!/bin/bash
 if [[ $EUID -eq 0 ]]; then
        
    kullanici_olustur(){
        
        read -p "Lütfen kullanıcı adınızı giriniz: " kullanici_adi
        if id "$kullanici_adi" >/dev/null 2>&1; then
            echo "Bu kullanıcı mevcut"
        else
            read -p "Kullanıcı oluşturulsun mu? (e/h)" secim
            if [ "$secim" = "e" ]; then
                useradd "$kullanici_adi"
                if [ $? -eq 0 ]; then
                    echo "Lütfen şifrenizi giriniz: "
                    passwd "$kullanici_adi"
                    if [ $? -eq 0 ]; then
                        echo "İşlem başarılı..."
                    else
                        echo "İşlem başarısız..."
                        return
                    fi
                else
                    echo "İşlem başarısız..."
                    return
                fi
            elif [ "$secim" = "h" ]; then
                echo "İşlem iptal ediliyor..."
                return
            fi
        fi
    }

    kullanici_sil(){
        read -p "Lütfen silmek istediğiniz kullanıcının adını giriniz: " kullanici_adi
        if id "$kullanici_adi" > /dev/null 2>&1; then
            
            read -p "$kullanici_adi kullanıcısını silmek istiyor musunuz? (e/h)" secim
            if [ "$secim" = "e" ]; then
                userdel "$kullanici_adi"
                kontrol
            elif [ "$secim" = "h" ]; then
                echo "İşlem iptal ediliyor..."
                return
            else
                echo "Hatalı bir işlem yaptınız..."
                return
            fi
        else
            echo "Bu kullanıcı mevcut değil.."
            return
        fi     
    }

    kullanici_bilgisi(){
        read -p "Lütfen bilgisini öğrenmek istediğiniz kullanıcıyı giriniz: " kullanici_adi
        if id "$kullanici_adi" > /dev/null 2>&1; then
            
            echo "UID : "
            id -u "$kullanici_adi"
            echo "GID : "
            id -g "$kullanici_adi"
            echo "Gruplar: "
            id -Gn "$kullanici_adi"
            echo "Ev dizini: "
            getent passwd "$kullanici_adi" | cut -d: -f6 
            echo "Kabuk: "
            getent passwd "$kullanici_adi" | cut -d: -f7
        else
            echo "Kullanıcı bulunamadı..."
        fi

    }

    kullanicinin_gruplari(){
        read -p "Lütfen bilgisini öğrenmek istediğiniz kullanıcıyı giriniz: " kullanici_adi
        if id "$kullanici_adi" > /dev/null 2>&1; then
            echo "Kullanıcının grupları: "
            id -Gn "$kullanici_adi"
        else
            echo "Kullanıcı bulunamadı..."
        fi
    }

    sifre_degistir(){
        read -p "Şifresi değiştirilecek kullanıcıyı giriniz : " kullanici_adi
        if id "$kullanici_adi" > /dev/null 2>&1; then
            passwd "$kullanici_adi"
        else
            echo "Kullanıcı bulunamadı"
        fi
    }

    kullanici_listele(){
        echo "Sistemdeki tüm kullanıcılar: "
        cut -d: -f1 /etc/passwd
    }

    kontrol(){
        durum=$?
        if [ "$durum" -eq 0 ]; then
            echo "İşlem başarılı..."
        elif [ "$durum" -ne 0 ]; then
            echo "İşlem başarısız..."
        fi
    }

    menu(){
        clear
        echo """
        ============================
            KULLANICI YÖNETİMİ
        ============================
        1) Kullanıcı oluştur
        2) Kullanıcı sil
        3) Kullanıcı bilgisi
        4) Kullanıcının grupları
        5) Şifre değiştir
        6) Tüm kullanıcıları listele
        0) Çıkış
        ============================
        """
    }

while true
do
    menu
    read -p "Lütfen seçiminizi giriniz : " secim
    case $secim in 

    0) 
        echo "Çıkış yapılıyor..."
        break
    ;;
    1)
        kullanici_olustur
    ;;
    2)
        kullanici_sil
    ;;
    3)
        kullanici_bilgisi
    ;;
    4)
        kullanicinin_gruplari
    ;;
    5)
        sifre_degistir
    ;;
    6)
        kullanici_listele
    ;;
    *)
        echo "Hatalı bir giriş yaptınız..."
    ;;
        esac
    read -p "Devam etmek için enter"
done

else 
    echo "Lütfen root olarak giriş yapınız..."
    exit 1
fi