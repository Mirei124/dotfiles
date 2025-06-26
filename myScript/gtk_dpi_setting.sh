#!/bin/bash

# KDE
# echo 'Xft.dpi: 120' | xrdb -m
# kreadconfig6 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors
# set to 0 to disable forceFontDPI
# kwriteconfig6 --file ~/.config/kcmfonts --group General --key forceFontDPI 120

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

  # integer
  _scale_int=$(echo "scale=0; $_scale/1" | bc)

  printf "\e[34m::\e[0m\e[1mscale=%s dpi=%s gtk_dpi=%s scale_int=%s\e[0m\n" "$_scale" "$_dpi" "$_gtk_dpi" "$_scale_int"

  # 1. xrdb
  xrdb -m <<EOF
Xft.dpi:${_dpi}
EOF

  # 2. xsettings global
  sed -Ei "s|(Gdk/WindowScalingFactor) .+\$|\1 ${_scale_int}|" ~/.config/xsettingsd/xsettingsd.conf
  # 3. xsettings text
  # remove 'Xft/DPI' if exists
  sed -i '/^Xft\/DPI/d' ~/.config/xsettingsd/xsettingsd.conf
  sed -Ei "s|(Gdk/UnscaledDPI) .+\$|\1 ${_gtk_dpi}|" ~/.config/xsettingsd/xsettingsd.conf

  # 4. gsettings global
  gsettings set org.gnome.desktop.interface scaling-factor "$_scale_int"
  # 5. gsettings text

  if [ "$XDG_CURRENT_DESKTOP" = 'KDE' ]; then
    printf 'Set text-scaling-factor to 1.0 on KDE'
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
  else
    gsettings set org.gnome.desktop.interface text-scaling-factor "$_scale"
  fi

  # 6. gtk settings
  sed -Ei "s|(gtk-xft-dpi)=.+\$|\1=${_gtk_dpi}|" ~/.config/gtk-3.0/settings.ini
  sed -Ei "s|(gtk-xft-dpi)=.+\$|\1=${_gtk_dpi}|" ~/.config/gtk-4.0/settings.ini

  # start xsettingsd
  systemctl --user stop xsettingsd.service
  sleep 1
  pkill xsettingsd || :
  systemctl --user start xsettingsd.service
}

get_dpi() {
  # show current config
  printf "\033[0;32m###############\n# current dpi #\n###############\033[0m\n"
  printf "\033[0;33mxrdb\033[0m\n"
  xrdb -q | grep dpi

  printf "\n\033[0;33mxsettings\033[0m\n"
  grep -E 'WindowScalingFactor|DPI' ~/.config/xsettingsd/xsettingsd.conf

  printf "\n\033[0;33mgsettings\033[0m\n"
  echo -n '/org/gnome/desktop/interface/scaling-factor='
  gsettings get org.gnome.desktop.interface scaling-factor
  echo -n '/org/gnome/desktop/interface/text-scaling-factor='
  gsettings get org.gnome.desktop.interface text-scaling-factor

  printf "\n\033[0;33mgtk\033[0m\n"
  grep dpi ~/.config/gtk-?.0/settings.ini

  printf "\n\033[0;33mQT\033[0m\n"
  printenv | grep QT_ | grep -E 'DPI|SCALE'
}

check_command bc
check_command xrdb
check_command gsettings

case "$*" in
  s | show)
    get_dpi
    ;;
  *)
    set_dpi "$*"
    ;;
esac

# vim: set ts=2 sw=2 et:
