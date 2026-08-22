#!/bin/bash

if [ -z "$(git status --porcelain)" ] #değişiklik yoksa
then
    echo "Değişiklik tespit edilmedi..."

else #değişiklik varsa
    deneme=$(git status --porcelain | awk '{print $2}')
    git add .
    if [ $? -eq 0 ]; then
        git commit -m "$deneme added"
        if [ $? -eq 0 ]; then
            git push
            if [ $? -eq 0 ]; then
                echo "İşlem başarılı..."
            else 
                echo "İşlem başarısız..."
            fi
        fi
    fi
fi