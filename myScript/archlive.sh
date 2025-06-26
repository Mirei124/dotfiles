#!/bin/bash

sudo pacman -S --needed archiso

dest='/tmp'
sudo rm -r "$dest"/releng
cp -r /usr/share/archiso/configs/releng "$dest"

# https://wiki.archlinux.org/title/PC_speaker#Globally
nobeep=$(
  cat <<EOF
blacklist pcspkr
blacklist snd_pcsp
EOF
)
echo "$nobeep" >"$dest"/releng/airootfs/etc/modprobe.d/nobeep.conf
sed -i '/^play/d' "$dest"/releng/grub/grub.cfg

mirrors=$(
  cat <<EOF
Server = https://opentuna.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.nju.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.hit.edu.cn/archlinux/\$repo/os/\$arch
EOF
)
echo "$mirrors" >"$dest"/releng/airootfs/etc/pacman.d/mirrorlist

packages=$(
  cat <<EOF
bash-completion
EOF
)
echo "$packages" >>"$dest"/releng/packages.x86_64

sed -i 's/\(iso_label=\)\(.\+\)/\1AI/' "$dest"/releng/profiledef.sh
sudo mkarchiso -v -w /tmp/archiso -o /tmp "$dest"/releng
