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
# wget https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh
zinit ice wait lucid from"gh-r" as"program" src"key-bindings.zsh"
zinit light junegunn/fzf

# theme
zinit ice wait"!" lucid
zinit snippet OMZ::themes/ys.zsh-theme

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
alias pcp="rsync -avhP"
alias vip="nvim PKGBUILD"

# set proxy
alias vpn="export http_proxy=http://127.0.0.1:7890 && export https_proxy=http://127.0.0.1:7890 && export all_proxy=socks5://127.0.0.1:7891"
alias vus="unset http_proxy https_proxy all_proxy"
alias vst="$HOME/myScript/proxy.sh"
alias ved="$HOME/myScript/proxy.sh ed"

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

################################################################################

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
condaInit() {
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
          . "/opt/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="/opt/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
}
# <<< conda initialize <<<

