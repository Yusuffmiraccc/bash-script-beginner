#!/bin/bash

Downloads="$HOME/Downloads"

for file in "$Downloads"/*
do
    
    case "$file" in
	*.jpg | *.JPG)
	mkdir -p "$Downloads/images/"
	mv "$file" "$Downloads/images";;

	*.pdf | *.PDF)
	mkdir -p "$Downloads/images/"
	mv "$file" "$Downloads/images";;

	*.mp4 | *.MP4)
	mkdir -p "$Downloads/images/"
	mv "$file" "$Downloads/images";;

	*)echo "Geçersiz parametre";;
	esac
done


