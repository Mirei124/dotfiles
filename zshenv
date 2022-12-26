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
dirss=(
~/.local/bin
~/.node_modules/bin
/usr/lib/ccache/bin
)
for dir in "${dirss[@]}"; do
  if [[ -z "${path[(r)$dir]}" ]]; then
    path=($dir $path)
  fi
done
