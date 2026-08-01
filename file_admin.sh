#!/bin/bash
kontrol(){
    if [ $? -eq 0 ]; then
        echo "✅ İşlem başarılı."
    else
        echo "❌ İşlem başarısız."
    fi
}

menu(){
    clear
    echo """
    ============================
        DOSYA YÖNETİCİSİ
    ============================
    0) Çıkış
    1) Bulunduğum klasörü göster
    2) Dosyaları listele
    3) Klasör oluştur
    4) Dosya oluştur
    5) Dosya kopyala
    6) Dosya taşı
    7) Dosya sil
    8) Klasör sil
    9) Dosya içeriğini göster
    ============================
    """
}

klasor_goster(){

    echo "Bulunduğum dizin= "
    pwd

}

dosya_listele(){

    ls -lah
}

klasor_olustur(){

    read -p "Lütfen klasör ismini giriniz= " klasor_isim
    mkdir "$klasor_isim"
    kontrol

}

dosya_olustur(){

    read -p "Lütfen dosya ismi ve uzantısını giriniz: " dosya_isim
    touch "$dosya_isim"
    kontrol
}

dosya_kopyala(){
    read -p "Lütfen kopyalanacak dosyayı yazınız: " kopyalanacak_dosya
    read -p "Lütfen kopyalanacak dosyayı giriniz: " kopyalanacak_isim

    cp "$kopyalanacak_dosya" "$kopyalanacak_isim"
    kontrol
}

dosya_tasi(){
    read -p "Lütfen taşınacak dosyayı yazınız: " tasinacak_dosya
    read -p "Lütfen taşınacak dizini giriniz: " tasinacak_dizin

    mv -v "$tasinacak_dosya" "$tasinacak_dizin"
    kontrol
}

dosya_sil(){
    ls -p | grep -v /
    read -p "Lütfen silmek istediğiniz dosyayı giriniz= " silinecek_dosya
    if [ -f "$silinecek_dosya" ]; then
        rm "$silinecek_dosya"
    
       kontrol
    else
        echo "Dosya bulunamadı..."
    fi
}

klasor_sil(){
    ls -d */
    read -p "Lütfen silmek istediğiniz klasörü giriniz= " silinecek_klasor
    if [ -d "$silinecek_klasor" ]; then
        rmdir "$silinecek_klasor"
    
        kontrol
    else
        echo "Klasör bulunamadı..."
    fi
}

icerik_goster(){
    ls -p | grep -v /
    read -p "Lütfen içeriği gösterilecek dosyayı giriniz: " girilen_dosya
    if [ -f "$girilen_dosya" ]; then
        cat "$girilen_dosya"
    else
        echo "Dosya bulunamadı..."
    fi
    kontrol
}

while true
do
    menu

    read -p "Lütfen birini seçiniz: " secim
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
            klasor_goster   
        ;;

        2)
            dosya_listele
        ;;

        3)
            klasor_olustur
        ;;

        4)
            dosya_olustur
        ;;

        5)
            dosya_kopyala
        ;;

        6)
            dosya_tasi
        ;;

        7)
            dosya_sil
        ;;

        8)
            klasor_sil
        ;;

        9)
            icerik_goster
        ;;

        *)
            echo "Hatalı işlem..."
        ;;

    esac
    read -p "Devam etmek için Enter..."
done