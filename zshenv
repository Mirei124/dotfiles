export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

# export allow_rgb10_configs=false
export _JAVA_AWT_WM_NONREPARENTING=1

export EDITOR=nvim
# export SXHKD_SHELL=bash

export LIBVA_DRIVER_NAME=nvidia
export VDPAU_DRIVER=radeonsi

# qt5ct
if [[ "$XDG_CURRENT_DESKTOP" != "KDE" ]]; then
    export QT_QPA_PLATFORMTHEME=qt5ct
fi

# wayland
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    export QT_WAYLAND_FORCE_DPI=120
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
    # export KITTY_DISABLE_WAYLAND=1
fi

# npm
export npm_config_prefix=~/.node_modules

# java
export JAVA_HOME=/usr/lib/jvm/default

# path
bins=(
~/.local/bin
~/.node_modules/bin
/usr/lib/ccache/bin
)
for d in "${bins[@]}"; do
  if [[ -z "${path[(r)$d]}" ]]; then
    if [[ -e $d ]]; then
      path=("$d" "${path[@]}")
    fi
  fi
done
unset bins d
export PATH
