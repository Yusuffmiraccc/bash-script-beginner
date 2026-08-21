#!/bin/bash

menu(){
    clear
    echo """
    ==============================
       SYSTEM INFORMATION PANEL
    =============================

    1) System Information
    2) Hostname Information
    3) System Uptime
    4) RAM Usage
    5) CPU Information
    6) Disk Information
    7) Show All System Information
    0) Exit

    ==============================
"""
}

system_info(){
    echo "System name: "
    uname
    echo "Kernel version: " 
    uname -r
    echo "architectural: "
    uname -m
}

hostname_info(){
    echo "Hostname information: "
    hostnamectl
}

system_uptime(){
    echo "System uptime: "
    uptime -p
}

RAM_usage(){
    echo "RAM usage: "
    free -h
}

CPU_info(){
    echo "CPU model:"
    lscpu | grep "Model name"

    echo "CPU core"
    lscpu | grep "Core(s) per socket"

    echo "Thread:"
    lscpu | grep "Thread(s) per core"
}

disk_info(){
    echo "Disk information: "
    lsblk -d -o NAME,SIZE,TYPE,MOUNTPOINT
}

all_system_info(){
    system_info
    echo "==============================="
    hostname_info
    echo "==============================="
    system_uptime
    echo "==============================="    
    RAM_usage
    echo "==============================="    
    CPU_info
    echo "==============================="
    disk_info
    echo "==============================="
}

while true
do
    menu
    read -p "Lütfen seçiminizi giriniz: " giris

    case $giris in
        0)
            echo "Exiting..."
            break
        ;;
        1)
            system_info
        ;;
        2)
            hostname_info
        ;;
        3)
            system_uptime
        ;;
        4)
            RAM_usage
        ;;
        5)
            CPU_info
        ;;
        6)
            disk_info
        ;;
        7)
            all_system_info
        ;;
        *)
            echo "You made a mistake!!"
        ;;

    esac
    read -p "enter to continue"
done