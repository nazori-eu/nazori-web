#!/bin/bash
echo "Removing old build"
rm -r public
rm -r /var/www/nazori/* 
echo "Publishing webiste"
hugo
cp -r public/* /var/www/nazori
echo "Website deployed"



