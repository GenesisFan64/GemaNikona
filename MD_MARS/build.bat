@echo off
cls
echo ** MEGA DRIVE **
"tools\AS\win32\asw" -i . md.asm -q -xx -c -A -olist "out\rom_md.lst" -A -L -D MCD=0,MARS=0,MARSCD=0,WPATCH=1
"tools\AS\win32\s2p2bin" md.p "out\rom_md.bin" md.h
del md.p
del md.h

echo ** MARS **
"tools\AS\win32\asw" -i . mars.asm -q -xx -c -A -olist "out\rom_mars.lst" -A -L -D MCD=0,MARS=1,MARSCD=0,WPATCH=1
"tools\AS\win32\s2p2bin" mars.p "out\rom_mars.bin" mars.h
del mars.p
del mars.h
