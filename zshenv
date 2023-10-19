export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

export EDITOR=nvim

export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER=radeonsi

# fix OMZ::plugins/colored-man-pages
export GROFF_NO_SGR=1

# wm
if [[ "$XDG_CURRENT_DESKTOP" != 'KDE' ]]; then
  export QT_QPA_PLATFORMTHEME=qt5ct
  export _JAVA_AWT_WM_NONREPARENTING=1
fi

# wayland
if [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
  export QT_WAYLAND_FORCE_DPI=120
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORM='wayland;xcb'
  # export KITTY_DISABLE_WAYLAND=1
  export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
fi

# nvidia
# export LIBVA_DRIVER_NAME=nvidia
# export VDPAU_DRIVER=nvidia
# export GBM_BACKEND=nvidia-drm
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
# export WLR_NO_HARDWARE_CURSORS=1

# https://github.com/elFarto/nvidia-vaapi-driver#firefox
# export NVD_BACKEND=direct
# export MOZ_DISABLE_RDD_SANDBOX=1

# npm
export npm_config_prefix=~/.node_modules

# java
export JAVA_HOME=/usr/lib/jvm/default

# path
dirs=(
/usr/lib/ccache/bin
~/.local/bin
~/.node_modules/bin
)
typeset -U path
path=($dirs $path)
unset dirs
#vim: set ft=zsh ts=2 sw=2 et:
