#!/bin/bash

set -euo pipefail

check_command() {
  if ! command -v "$1" >/dev/null; then
    printf "\e[1;31mcommand %s not found\e[0m\n" "$1"
    exit 1
  fi
}

set_dpi() {
  # get scale
  _scale="$*"
  if [[ -z "$_scale" ]]; then
    _scale=1.25
  fi

  # convert to float
  _scale=$(echo "${_scale} * 1.0" | bc)
  if [[ -z "$_scale" ]]; then
    printf "\e[1;31minput error\e[0m\n"
    exit 1
  fi

  # calculate dpi
  _dpi=$(echo "${_scale} * 96" | bc | cut -d'.' -f1)
  if [[ -z "$_dpi" || "$_dpi" == '0' || "$_dpi" == *'-'* ]]; then
    printf "\e[1;31minput error\e[0m\n"
    exit 1
  fi

  # calculate gtk dpi
  _gtk_dpi=$((_dpi * 1024))

  printf "\e[34m::\e[0m\e[1mscale=%s dpi=%s gtk_dpi=%s\e[0m\n" "$_scale" "$_dpi" "$_gtk_dpi"

  # 1. xrdb
  xrdb -m <<EOF
Xft.dpi:${_dpi}
EOF

  # 2. xsettings
  sed -Ei "s|(Gdk/UnscaledDPI) .+\$|\1 ${_gtk_dpi}|" ~/.config/xsettingsd/xsettingsd.conf

  # 3. gtk settings
  sed -Ei "s|(gtk-xft-dpi)=.+\$|\1=${_gtk_dpi}|" ~/.config/gtk-3.0/settings.ini
  sed -Ei "s|(gtk-xft-dpi)=.+\$|\1=${_gtk_dpi}|" ~/.config/gtk-4.0/settings.ini

  # 4. dconf
  dconf write /org/gnome/desktop/interface/text-scaling-factor "$_scale"

  # start xsettingsd
  systemctl --user stop xsettingsd.service
  sleep 1
  pkill xsettingsd || :
  systemctl --user start xsettingsd.service
}

get_dpi() {
  # show current config
  printf "\033[0;32m###############\n# current dpi #\n###############\033[0m\n"
  xrdb -q | grep dpi
  grep DPI ~/.config/xsettingsd/xsettingsd.conf
  grep dpi ~/.config/gtk-?.0/settings.ini
  echo -n '/org/gnome/desktop/interface/text-scaling-factor='
  dconf read /org/gnome/desktop/interface/text-scaling-factor
  printf "QT_WAYLAND_FORCE_DPI=%s\n" "$QT_WAYLAND_FORCE_DPI"
}

check_command bc
check_command xrdb
check_command dconf

case "$*" in
s | show)
  get_dpi
  ;;
*)
  set_dpi "$*"
  ;;
esac

# vim: set ts=2 sw=2 et:
