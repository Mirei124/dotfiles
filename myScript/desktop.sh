#!/bin/bash

targets=(suspend hibernate poweroff reboot)
for i in "${targets[@]}"; do
  iconName="${i/poweroff/shutdown}"
  echo "[Desktop Entry]
Name=$i
Comment=$i
Type=Application
Exec=systemctl $i
Icon=system-$iconName" >"$HOME/.local/share/applications/$i.desktop"
done
