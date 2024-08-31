# im #######################################################
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

# Qt 6.7
export QT_IM_MODULES="wayland;fcitx;ibus"

if [ "$XDG_SESSION_TYPE" = 'wayland' ]; then
  unset GTK_IM_MODULE

  if [ "$XDG_CURRENT_DESKTOP" = 'KDE' ]; then
    unset QT_IM_MODULE
  fi
fi

# wm #######################################################
if [ "$XDG_CURRENT_DESKTOP" != 'KDE' ]; then
  export QT_QPA_PLATFORMTHEME=qt5ct
  export _JAVA_AWT_WM_NONREPARENTING=1
fi

# wayland ##################################################
if [ "$XDG_SESSION_TYPE" = 'wayland' ]; then
  export QT_QPA_PLATFORM='wayland;xcb'
  export QT_WAYLAND_FORCE_DPI=120

  export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

  # program
  export MOZ_ENABLE_WAYLAND=1
fi

# misc #####################################################
export EDITOR=nvim

export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER=radeonsi

# fix OMZ::plugins/colored-man-pages
export GROFF_NO_SGR=1

# nvidia ###################################################
# export LIBVA_DRIVER_NAME=nvidia
# export VDPAU_DRIVER=nvidia
# export GBM_BACKEND=nvidia-drm
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
# export WLR_NO_HARDWARE_CURSORS=1

# vaapi for firefox
# export NVD_BACKEND=direct
# export MOZ_DISABLE_RDD_SANDBOX=1

# lang #####################################################
# android
export ANDROID_HOME=~/Android/Sdk

# java
export JAVA_HOME=/usr/lib/jvm/default

# npm
export npm_config_prefix=~/.node_modules

# python
export MAMBA_ROOT_PREFIX=~/.conda

# path #####################################################
dirs=(
  /usr/lib/ccache/bin
  ~/.cargo/bin
  ~/.local/bin
  ~/.local/share/JetBrains/Toolbox/scripts
  ~/.node_modules/bin
)
typeset -U path
for d in "${dirs[@]}"; do
  if [[ -e "$d" ]]; then
    # shellcheck disable=SC2206
    path=($d $path)
  else
    printf "zshenv=>PATH: \033[1;31m%s not exists.\033[0m\n" "$d"
  fi
done
unset dirs d

# vim: set ft=zsh ts=2 sw=2 et cc=61:
