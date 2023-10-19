source /usr/share/zinit/zinit.zsh

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
  agkozak/zsh-z \

# omz
zinit snippet OMZ::lib/history.zsh
zinit wait lucid light-mode for \
  OMZ::lib/clipboard.zsh \
  OMZ::lib/completion.zsh \
  OMZ::lib/git.zsh \
  OMZ::plugins/git \
  OMZ::plugins/colored-man-pages \
  OMZ::plugins/common-aliases \
  OMZ::lib/prompt_info_functions.zsh \
  OMZ::lib/theme-and-appearance.zsh

# fzf
# load fzf after OMZ::lib/key-bindings.zsh to avoid overwritting
zinit snippet OMZ::lib/key-bindings.zsh
# manually download:
# zinit cd junegunn/fzf
# curl -OL https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh
_key_bindings="$HOME/.local/share/zinit/plugins/junegunn---fzf/key-bindings.zsh"
if [ ! -f "$_key_bindings" ]; then
  curl -fsSL https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh \
    -o "$_key_bindings"
fi
unset _key_bindings
zinit ice wait lucid from"gh-r" as"program" src"key-bindings.zsh"
zinit light junegunn/fzf

# theme
zinit ice wait"!" lucid
zinit snippet OMZ::themes/steeef.zsh-theme
# zinit snippet OMZ::themes/ys.zsh-theme
# zinit light dracula/zsh

# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure

################################################################################
# custom

alias vi="nvim"
alias stu="systemctl status"
alias sta="systemctl start"
alias sto="systemctl stop"
alias str="systemctl restart"
alias ste="systemctl enable"
alias std="systemctl disable"
# alias tt="tldr -t ocean"
alias tt="tldr"
alias pa="sudo pacman"
alias tb="setterm --blank force"
alias tp="setterm --blank poke"
# alias pcp="rsync -ah --info=progress2"
# https://github.com/lilydjwg/dotzsh/blob/master/zshrc#L449
alias pcp="rsync -aviHAXKhS --one-file-system --partial --info=progress2 --atimes --open-noatime --exclude='*~' --exclude=__pycache__"
alias vip="nvim PKGBUILD"
alias :q='exit'
alias tma='if command tmux has; then command tmux a; else systemd-run --user --scope tmux; fi'
alias pyv='source ~/.pyvenv/bin/activate'

# set proxy
alias vpn="export http_proxy=http://127.0.0.1:7890 && export https_proxy=http://127.0.0.1:7890 && export all_proxy=socks5://127.0.0.1:7891"
alias vus="unset http_proxy https_proxy all_proxy"
alias vst="~/myScript/proxy.sh"
alias ved="~/myScript/proxy.sh ed"

alias pas='expac -HM "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <({ pacman -Qqg base-devel; expac -l n %E base; } | sort -u)) | sort -n | tail -n 40'
alias pad="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 40"

uzp() {
  unzip -O gbk "$1" -d "${1%.zip}"
}

bw() {
	(exec bwrap --unshare-all --die-with-parent --share-net --ro-bind / / \
		--tmpfs /sys --tmpfs /home --tmpfs /tmp --tmpfs /run \
		--proc /proc --dev /dev \
		--ro-bind-try ~/.fonts ~/.fonts \
		--ro-bind ~/.config/fontconfig ~/.config/fontconfig \
		--bind ~/.cache/fontconfig ~/.cache/fontconfig \
		--ro-bind ~/.Xauthority ~/.Xauthority \
		--ro-bind /tmp/.X11-unix /tmp/.X11-unix \
		--ro-bind /run/user/$UID/bus /run/user/$UID/bus \
		--ro-bind /run/user/$UID/pipewire-0 /run/user/$UID/pipewire-0 \
		--ro-bind /run/user/$UID/wayland-1 /run/user/$UID/wayland-1 \
		--bind $PWD ~/bw --chdir ~/bw \
		--setenv PS1 "bw$ " \
		--setenv WINEPREFIX "$HOME/wine" \
		/bin/bash)
}

gpgenc() {
  gpg --batch \
    --pinentry-mode loopback \
    --passphrase "${p:-12345678}" \
    --no-symkey-cache \
    --yes \
    -o "${d:-.}/$(echo "$1" | base64).gpg" -c "$1"
}

gpgdec() {
  if fn=$(echo "${1%.gpg}" | base64 -d); then
    echo -en "\033[0;32mdecrypt \"$fn\"?[y/n]\033[0m"
    read choice
    if [[ "$choice" == [yY]* ]]; then
      gpg --batch \
        --pinentry-mode loopback \
        --passphrase "${p:-12345678}" \
        --yes \
        -o "${d:-.}/$fn" -d "$1"
    fi
  fi
}

startAndDisown() {
  nohup "$@" &>/dev/null & disown
}
alias sr='startAndDisown'

fdc() {
  fd -d2 "$@" ~/.config ~/.cache ~/.local/share ~/.local/lib
}

watchSync() {
  watch -n3 'grep -E "(Dirty|Write)" /proc/meminfo; echo; ls /sys/block/ | while read device; do [[ $device != loop* ]] && awk "{ print \"$device:\\n  in_flight: \" \$9 \"\\n  write ticks: \" \$8/1000 \"\\n\" }" "/sys/block/$device/stat"; done'
}

################################################################################

source /opt/miniconda/etc/profile.d/conda.sh

