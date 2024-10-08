#!/bin/bash

sdir="$HOME"/themes

log() {
  echo -e "\033[0;32m$1\033[0m"
}

uninstall() {
  log 'uninstalling Layan-cursors...'
  rm -rfv "$HOME"/.local/share/icons/Layan-cursors
  rm -rfv "$HOME"/.local/share/icons/Layan-border-cursors
  rm -rfv "$HOME"/.local/share/icons/Layan-white-cursors

  log 'uninstalling Tela-icon-theme...'
  rm -rfv "$HOME"/.local/share/icons/Tela*

  log 'uninstalling Layan-gtk-theme...'
  rm -rfv "$HOME"/.themes/Layan*

  log 'uninstalling Fluent-gtk-theme...'
  rm -rfv "$HOME"/.themes/Fluent*

  log 'uninstalling Layan-kde...'
  rm -rfv "$HOME"/.local/share/plasma/look-and-feel/com.github.vinceliuice.Layan*
  uninstall_kde Layan

  log 'uninstalling Win11OS-kde...'
  rm -rfv "$HOME"/.local/share/plasma/look-and-feel/com.github.yeyushengfan258.Win11OS*
  uninstall_kde Win11OS

  log 'uninstalling Orchis-theme'
  rm -rfv "$HOME"/.themes/Orchis*

  log 'uninstalling Orchis-kde'
  rm -rfv "$HOME"/.local/share/plasma/look-and-feel/com.github.vinceliuice.Orchis*
  uninstall_kde Orchis
}

uninstall_kde() {
  PREFIX="$1"
  if [[ -z "$PREFIX" ]]; then
    log 'Failed: PREFIX is empty'
    return 1
  fi

  rm -rfv "$HOME"/.local/share/aurorae/themes/${PREFIX}*
  rm -rfv "$HOME"/.local/share/color-schemes/${PREFIX}*.colors
  rm -rfv "$HOME"/.local/share/plasma/desktoptheme/${PREFIX}*
  rm -rfv "$HOME"/.config/Kvantum/${PREFIX}*
  rm -rfv "$HOME"/.local/share/wallpapers/${PREFIX}*
  rm -rfv "$HOME"/.config/Kvantum/${PREFIX}*
}

update() {
  for loop in */; do
    log "updating $loop"
    cd "$loop" || exit
    git pull
    cd "$sdir" || exit
  done
}

install() {
  pacman -Qi sassc >/dev/null || log 'Install sassc first'
  sudo pacman -S --needed --asdeps sassc

  # log 'installing kwin-tiling...'
  # cd ./kwin-tiling || exit
  # plasmapkg2 --type kwinscript -u .
  # cd $sdir || exit

  log 'installing Layan-cursors...'
  cd ./Layan-cursors || exit
  ./install.sh
  cd "$sdir" || exit

  # log 'installing Layan-kde...'
  # cd ./Layan-kde || exit
  # ./install.sh
  # cp -r ./Kvantum/* "$HOME"/.config/Kvantum/
  # cd "$sdir" || exit

  # log 'installing Layan-gtk-theme...'
  # cd ./Layan-gtk-theme || exit
  # ./install.sh -l
  # cd "$sdir" || exit

  # log 'installing Fluent-gtk-theme...'
  # cd ./Fluent-gtk-theme || exit
  # pacman -Qi sassc || sudo pacman -S --asdeps sassc
  # ./install.sh -t pink -s compact -i endeavouros --tweaks noborder
  # cd "$sdir" || exit

  log 'installing Tela-icon-theme...'
  cd ./Tela-icon-theme || exit
  ./install.sh
  cd "$sdir" || exit

  # log 'installing Win11OS-kde...'
  # cd ./Win11OS-kde || exit
  # ./install.sh
  #  cp -r ./Kvantum/* "$HOME"/.config/Kvantum/
  # cd "$sdir" || exit

  log 'installing Orchis-theme...'
  cd ./Orchis-theme || exit
  ./install.sh -t default -c light -s standard -l
  cd "$sdir" || exit

  log 'installing Orchis-kde...'
  cd ./Orchis-kde || exit
  ./install.sh
  cd "$sdir" || exit
}

if [[ $# -ge 1 ]]; then
  if [[ $1 = 'update' ]]; then
    update
  elif [[ $1 = 'uninstall' ]]; then
    uninstall
  elif [[ $1 = 'install' ]]; then
    install
  fi
else
  cat <<EOF
$0 [option] install uninstall update
EOF
fi

#vim: set ft=sh ts=2 sw=2 et:
