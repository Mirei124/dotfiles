#!/bin/bash

if [[ -n "$*" ]]; then
  dbus-send --session --print-reply=literal --dest=org.freedesktop.PowerManagement /org/kde/Solid/PowerManagement/Actions/BrightnessControl org.kde.Solid.PowerManagement.Actions.BrightnessControl.setBrightness int32:$(("$*" * 255 / 100))
  # sed -Ei 's/^(value=)[0-9]+$/\1'"$*"'/' ~/.config/powermanagementprofilesrc
  # sed -Ei 's|^(DisplayBrightness=)[0-9]+$|\1'"$*"'|g' ~/.config/powerdevilrc
else
  printf "\033[1;31mPlease provide brightness value (0-100)\033[0m\n"
fi
