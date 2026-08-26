#!/bin/bash

menu(){
    clear
    echo """
========================================
          DISK ANALYSIS TOOL
========================================

1) Show disk usage
2) Find the directories taking up the most space
3) Find the largest files
4) Show disk usage percentage
5) Show disk information
6) Check disk warnings
7) Full disk analysis
0) Exit

========================================
"""
}

disk_usage_show(){
    echo " Disk Usage "
    df -h | grep -E "/dev/|Filesystem" 
    echo "========================================"
}

most_used_directories(){
    read -p "Lütfen analiz edilecek dizini giriniz: " dizin

    du -h --max-depth=1 "$dizin" 2>/dev/null | sort -hr | head -n 5
    echo "========================================"

}

biggest_files(){

    read -p "Lütfen analiz edilecek dizini giriniz: " dizin

    find "$dizin" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n 10
    echo "========================================"

    
}

disk_usage_percentage(){
    
    df -h | grep '^/dev/' | awk '{
        usage=$5
        gsub("%", "", usage)

        if (usage<70)
            status="NORMAL"
        else if (usage<90)
            status="WARNING"
        else
            status="CRITICAL"
    
        print $1 " -> " usage "% -> " status
    }'

    echo "========================================"

    }

disk_information_show(){
    lsblk -o NAME,SIZE,TYPE | grep -E "disk|part|NAME" | awk '{print $1, $2}'
}

disk_alert_check(){
    sonuc=$(disk_usage_percentage | grep -E "WARNING|CRITICAL")

    if [ $? -eq 0 ]; then
        echo "$sonuc"
    else 
        echo "All disks are normal"
    fi
    echo "========================================"

}

full_disk_analysis(){
    disk_usage_show
    echo "========================================"
    most_used_directories
    echo "========================================"
    biggest_files
    echo "========================================"
    disk_usage_percentage
    echo "========================================"
    disk_information_show
    echo "========================================"
}

while true
do  

    menu
    read -p "Please enter the option you wish to use." secim

    case $secim in
    0) 
        echo "Çıkış yapılıyor..."
        break
    ;;
    1)
        disk_usage_show
    ;;
    2)
        most_used_directories
    ;;
    3)
        biggest_files
    ;;
    4)
        disk_usage_percentage
    ;;
    5)
        disk_information_show
    ;;
    6)
        full_disk_analysis
    ;;
    *)
        echo "Eksik ya da hatalı bir işlem yaptınız..."
    ;;
    esac

    read -p "Enter to continue" 

done