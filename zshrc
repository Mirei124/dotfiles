source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

################################################################################
# zinit config

# Most themes use this option
setopt promptsubst

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
  zsh-users/zsh-completions \
  agkozak/zsh-z

# omz
# load history.zsh first to avoid zsh-autosuggestions not working on startup
zinit snippet OMZ::lib/history.zsh
zinit wait lucid light-mode for \
  OMZ::lib/async_prompt.zsh \
  OMZ::lib/clipboard.zsh \
  OMZ::lib/completion.zsh \
  OMZ::lib/git.zsh \
  OMZ::lib/key-bindings.zsh \
  OMZ::lib/prompt_info_functions.zsh \
  OMZ::lib/theme-and-appearance.zsh \
  OMZ::plugins/colored-man-pages \
  OMZ::plugins/common-aliases \
  OMZ::plugins/git

zinit light zdharma-continuum/zinit-annex-patch-dl
zinit ice wait'1' lucid from'gh-r' as'program' pick'*linux_amd64*' \
  atclone'fzf --zsh > fzf.zsh' atpull'%atclone' src'fzf.zsh'
zinit light junegunn/fzf

# theme
zinit ice wait"!" lucid
zinit snippet "${HOME}/.neko.zsh-theme"
# zinit snippet OMZ::themes/steeef.zsh-theme
# zinit snippet OMZ::themes/ys.zsh-theme
# zinit light dracula/zsh

# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure

# fast-theme -t XDG:catppuccin-mocha

# options
REPORTTIME=5

################################################################################
# custom

alias vi="nvim"
alias stu="systemctl status"
alias sta="systemctl start"
alias sto="systemctl stop"
alias str="systemctl restart"
alias ste="systemctl enable"
alias std="systemctl disable"
alias stuu="systemctl --user status"
alias stau="systemctl --user start"
alias stou="systemctl --user stop"
alias stru="systemctl --user restart"
alias steu="systemctl --user enable"
alias stdu="systemctl --user disable"
# alias tt="tldr -t ocean"
alias tt="tldr"
alias pa="sudo pacman"
alias tb="setterm --blank force"
alias tp="setterm --blank poke"
# https://github.com/lilydjwg/dotzsh/blob/master/zshrc#L449
# alias xcp="rsync -aviHAXKhS --one-file-system --partial --info=progress2 --atimes --open-noatime --exclude='*~' --exclude=__pycache__"
alias xcp="rsync -ah --partial --info=progress2,stats --exclude='*~' --exclude=__pycache__"
alias vip="nvim PKGBUILD"
alias :q='exit'
alias pyv='source ~/.pyvenv/bin/activate'
alias btctl='bluetoothctl'
alias svi='sudo -E nvim'
alias pasd='sudo pacman -S --asdeps'
alias ssh='TERM=xterm-256color ssh'
alias wpre='export WINEPREFIX=$(pwd)/wine_root && echo \$WINEPREFIX=${WINEPREFIX}'
alias curlt='curl -w "\nnslookup: %{time_namelookup}\nconnect:  %{time_connect}\ntotal:    %{time_total}\nspeed:    %{speed_download}\n" -H "User-Agent: yes-please/2000"'
alias mtu='mount -ouid=1000,gid=1000'
alias rdp='xfreerdp /network:lan /gfx:AVC420 +gfx-progressive /video /size:1728x972 /dynamic-resolution +clipboard'
alias rdps='xfreerdp /network:lan /gfx:AVC420 +gfx-progressive /video /size:1728x972 /dynamic-resolution +clipboard /sound:sys:pulse,format:1 /microphone:sys:pulse,format:1'
# alias rdp='xfreerdp3 /network:lan /gfx:AVC420:on,progressive:on /video /f +clipboard'
# alias rdps='xfreerdp3 /network:lan /gfx:AVC420:on,progressive:on /video /f +clipboard /sound:sys:pulse /mic:sys:pulse,format:1'
alias daelog=$'journalctl -fu dae.service | sed -En \'s#.+<-> (.+) dialer=(.+) dscp.+#\\1\\t\\2#p\''
alias ip='ip --color'

# set proxy
alias vpn="export http_proxy=http://127.0.0.1:7890 && export https_proxy=http://127.0.0.1:7890 && export all_proxy=socks5://127.0.0.1:7890"
alias vus="unset http_proxy https_proxy all_proxy"
alias vst="~/myScript/proxy.sh"
alias ved="~/myScript/proxy.sh ed"

alias pas='expac -HM "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(expac -l n %E base | sort -u)) | sort -n | tail -n 40'
# alias pad="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 40"
alias pad=$'expac --timefmt=\'%Y-%m-%d %T\' \'%w\t%l\t%n\' | grep ^e | cut -f2- | sort | fzf --tac --preview=\'a={};expac -HM "Name     : %n\nGroups   : %G\nIns Size : %m\nRequi By : %N" ${a:20}\' --bind=\'enter:execute(a={};pacman -Qi ${a:20}|less),ctrl-/:execute(a={};sudo pacman -Rns ${a:20}||read)\''

uzp() {
  unzip -O gbk "$1" -d "${1%.zip}"
}

bw() {
  local _bwrap_prefix=(bwrap --unshare-all --die-with-parent --share-net --ro-bind / /
    --tmpfs /sys --tmpfs /home --tmpfs /tmp --tmpfs /run
    --proc /proc --dev /dev
    --ro-bind-try ~/.fonts ~/.fonts
    --ro-bind ~/.config/fontconfig ~/.config/fontconfig
    --bind ~/.cache/fontconfig ~/.cache/fontconfig
    --ro-bind ~/.Xauthority ~/.Xauthority
    --ro-bind /tmp/.X11-unix /tmp/.X11-unix
    --ro-bind /run/user/$UID/bus /run/user/$UID/bus
    --ro-bind /run/user/$UID/pipewire-0 /run/user/$UID/pipewire-0
    --ro-bind-try /run/user/$UID/wayland-1 /run/user/$UID/wayland-1
    --bind $PWD $PWD
    --setenv WINEPREFIX $PWD/wine_root)
  if [ -z "$*" ]; then
    "${_bwrap_prefix[@]}" /usr/bin/bash
  else
    "${_bwrap_prefix[@]}" "$@"
  fi
}

# https://github.com/lilydjwg/dotzsh/blob/master/zshrc#L405C18-L405C18
makepkg() {
  local _makepkg_prefix=(
    bwrap --unshare-all --share-net --die-with-parent
    --ro-bind /usr /usr --ro-bind /opt /opt --ro-bind /etc /etc --proc /proc --dev /dev --tmpfs /tmp
    --symlink usr/bin /bin --symlink usr/bin /sbin --symlink usr/lib /lib --symlink usr/lib /lib64
    --ro-bind /var/lib/pacman /var/lib/pacman --bind ~/.makepkg ~
    --bind ~/.ccache ~/.ccache --bind ~/.cache ~/.cache
    --ro-bind ~/myScript ~/myScript
    --ro-bind ~/.config/modprobed.db ~/.config/modprobed.db
    --bind ~/.rustup ~/.rustup
    # --ro-bind /run/dbus/system_bus_socket /run/dbus/system_bus_socket
    --setenv FAKEROOTDONTTRYCHOWN 1
  )
  "${_makepkg_prefix[@]}" --bind $PWD $PWD /usr/bin/makepkg "$@"
}

gpgenc() {
  for i in "$@"; do
    gpg --batch \
      --pinentry-mode loopback \
      --passphrase "${p:-12345678}" \
      --no-symkey-cache \
      --yes \
      -o "${d:-.}/$(echo "$i" | base64).gpg" -c "$i"
  done
}

gpgdec() {
  for i in "$@"; do
    if fn=$(echo "${i%.gpg}" | base64 -d); then
      echo -en "\033[0;32mdecrypt \"$fn\"?[y/n]\033[0m"
      read choice
      if [[ "$choice" == [yY]* ]]; then
        gpg --batch \
          --pinentry-mode loopback \
          --passphrase "${p:-12345678}" \
          --yes \
          -o "${d:-.}/$fn" -d "$i"
      fi
    fi
  done
}

startAndDisown() {
  nohup "$@" &>/dev/null &
  disown
}
alias sr='startAndDisown'

fdc() {
  fd -Hg -d2 "*$**" ~/.config ~/.cache ~/.local/share ~/.local/lib ~/.local/state
  fd -Hg -d1 "*$**" ~
}

watchSync() {
  watch -n3 'grep -E "(Dirty|Write)" /proc/meminfo; echo; ls /sys/block/ | while read device; do [[ $device != loop* ]] && awk "{ print \"$device:\\n  in_flight: \" \$9 \"\\n  write ticks: \" \$8/1000 \"\\n\" }" "/sys/block/$device/stat"; done'
}

tma() {
  if [ -n "$1" ]; then
    session=$1
  else
    session='sd'
  fi
  if command tmux has -t ${session}; then
    command tmux attach -t ${session}
  else
    systemd-run --user --scope $(which tmux) new -s ${session}
  fi
}

f() {
  awk '/MemTotal/ { total = $2 / 1024 }
/MemFree/ { free = $2 / 1024 }
/MemAvailable/ { avail = $2 / 1024 }
/SwapTotal/ { sTotal = $2 / 1024 }
/SwapFree/ { sFree = $2 / 1024
nextfile }
END { printf "free: %dM|%d%% avail: %dM|\033[1;32m%d\033[0m%% total: %dM\n", free, free / total * 100, avail, avail / total * 100, total
if (sTotal > 0) { printf "swap: free: %dM|\033[1;32m%d\033[0m%% total: %dM\n", sFree, sFree / sTotal * 100, sTotal } }' </proc/meminfo
}

optdep() {
  LC_ALL=C pacman -Qi "$@" | awk '
BEGIN {f=0}
!f && /Optional Deps/ {f=1;if ($0 !~ /installed/){sub(":","",$4);printf "%s ",$4};next}
f && /Required By/ {f=0;print "";nextfile}
f && $0 !~ /installed/ {sub(":","",$1);printf "%s ",$1}
'
}

gitver() {
  local IS_DIRTY
  if [ -z "$(git status --porcelain)" ]; then
    IS_DIRTY=''
  else
    IS_DIRTY='-dirty'
  fi
  printf "%s-r%s.%s%s\n" "$(git rev-parse --abbrev-ref HEAD)" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)" $IS_DIRTY
}

sshl() {
  ssh -NTL $1:127.0.0.1:$1 $2 $3
}

sshr() {
  ssh -NTR $1:127.0.0.1:$1 $2 $3
}

################################################################################

# source /opt/miniconda/etc/profile.d/conda.sh

condaInit() {
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/usr/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/k/.conda';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
micromamba activate mmseg
alias conda=micromamba
}

