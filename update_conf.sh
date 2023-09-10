#!/bin/bash

function add(){
    dest=$PWD
    
    # nvim old config
    # mkdir -p $dest/config/nvim
    # cp $HOME/.config/nvim/init.vim $dest/config/nvim/
    # cp $HOME/.config/nvim/coc-settings.json $dest/config/nvim/
    
    # nvim lua config
    mkdir -p $dest/config/nvim
    cp -r $HOME/.config/nvim/{init.lua,lua,my_snippets} $dest/config/nvim/
    rm -f ./config/nvim/lua/.luarc.json
    
    mkdir -p $dest/config/fontconfig/conf.d
    # cp $HOME/.config/fontconfig/fonts.conf $dest/config/fontconfig/
    cp $HOME/.config/fontconfig/conf.d/50-generic.conf $dest/config/fontconfig/conf.d/
    cp $HOME/.config/fontconfig/conf.d/51-language-noto-cjk.conf $dest/config/fontconfig/conf.d/
    cp $HOME/.config/fontconfig/conf.d/52-replace.conf $dest/config/fontconfig/conf.d/
    
    mkdir -p $dest/aria2
    cp $HOME/.aria2/aria2.conf $dest/aria2/
    sed -Ei "s#rpc-secret=\w+#rpc-secret=#g" aria2/aria2.conf
    sed -Ei 's#^(bt-tracker=[^,]+),.+$#\1#' aria2/aria2.conf
    
    cp $HOME/.zshrc $dest/zshrc
    
   # mkdir -p $dest/myScript/careEye
   # cp $HOME/myScript/careEye/care_eye.py $dest/myScript/careEye/
   # cp $HOME/myScript/careEye/start_care_eye.sh $dest/myScript/careEye/
   mkdir -p $dest/myScript/
   cp $HOME/myScript/desktop.sh $dest/myScript/
   cp $HOME/myScript/proxy.sh $dest/myScript/
   cp $HOME/myScript/mirror_speed.py $dest/myScript/

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

    cp -r $HOME/.config/waybar $dest/config/
    cp $HOME/.config/wayfire.ini $dest/config/

    mkdir -p $dest/config/mako
    cp $HOME/.config/mako/config $dest/config/mako/

    mkdir -p $dest/config/swaylock
    cp $HOME/.config/swaylock/config $dest/config/swaylock/

    mkdir -p $dest/config/wofi
    cp $HOME/.config/wofi/style.css $dest/config/wofi/

    mkdir -p $dest/config/mpd
    cp $HOME/.config/mpd/mpd.conf $dest/config/mpd/

    mkdir -p $dest/config/ncmpcpp
    cp $HOME/.config/ncmpcpp/config $dest/config/ncmpcpp/
    cp $HOME/.config/ncmpcpp/bindings $dest/config/ncmpcpp/

    cp -r $HOME/.config/swaync $dest/config/
}

add
