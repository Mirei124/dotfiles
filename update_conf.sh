#!/bin/bash

function add(){
    dest=$HOME/Documents/dotconfig
    
    mkdir -p $dest/config/nvim
    cp $HOME/.config/nvim/init.vim $dest/config/nvim/
    cp $HOME/.config/nvim/coc-settings.json $dest/config/nvim/
    
    mkdir -p $dest/config/fontconfig
    cp $HOME/.config/fontconfig/fonts.conf $dest/config/fontconfig/
    
    mkdir -p $dest/aria2
    cp $HOME/.aria2/aria2.conf $dest/aria2/
    sed -ri "s#rpc-secret=\w+#rpc-secret=#g" aria2/aria2.conf
    
    cp $HOME/.zshrc $dest/zshrc
    
    cp -r $HOME/myScript $dest
    rm $dest/myScript/careEye/log_care_eye.txt
    
    mkdir -p $dest/themes
    cp $HOME/themes/themes.sh $dest/themes/
    
    mkdir -p $dest/config/bspwm
    cp -r $HOME/.config/bspwm $dest/config/

    mkdir -p $dest/config/polybar
    cp -r $HOME/.config/polybar $dest/config/

    mkdir -p $dest/config/rofi/themes
    cp $HOME/.config/rofi/config.rasi $dest/config/rofi/
    cp $HOME/.config/rofi/themes/forest.rasi $dest/config/rofi/themes/
    cp $HOME/.config/rofi/themes/forest_colors.rasi $dest/config/rofi/themes/
    cp $HOME/.config/rofi/themes/cloud.rasi $dest/config/rofi/themes/
    
    mkdir -p $dest/config/sxhkd
    cp -r $HOME/.config/sxhkd $dest/config/

    mkdir -p $dest/etc/xdg
    cp /etc/xdg/picom.conf $dest/etc/xdg/

    cp $HOME/.zshenv $dest/zshenv

    mkdir -p $dest/config/i3
    cp $HOME/.config/i3/config $dest/config/i3/

    mkdir -p $dest/config/fcitx5/conf
    cp $HOME/.config/fcitx5/config $dest/config/fcitx5/
    cp $HOME/.config/fcitx5/conf/classicui.conf $dest/config/fcitx5/conf/

    cp -r $HOME/.config/dunst $dest/config/
}

add
