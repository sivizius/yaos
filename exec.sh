#!/bin/bash

if [[ -f "/usr/bin/qemu-system-i386" ]]
then
  echo "== create ISO-image =="                                       2>&1 | tee -a "../build/out/yaos.log"
    grub-mkrescue -o "../build/yaos/yaos.iso" "../build/yaos/"        2>&1 | tee -a "../build/out/yaos.log"
  echo "== test OS =="                                                2>&1 | tee -a "../build/out/yaos.log"
    qemu-system-i386 -cdrom "../build/yaos/yaos.iso" -d int,cpu_reset 2>&1 | tee -a "../build/out/yaos.log"
  echo "== done =="                                                   2>&1 | tee -a "../build/out/yaos.log"
else
  echo "fail: need qemu to run yaos"                                  2>&1 | tee -a "../build/out/yaos.log"
  echo "try sudo apt-get install qemu"                                2>&1 | tee -a "../build/out/yaos.log"
  exit 1
fi