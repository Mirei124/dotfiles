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
zinit snippet OMZ::lib/key-bindings.zsh
# zinit light zdharma-continuum/zinit-annex-patch-dl
zinit ice wait lucid from"gh-r" as"program" src"key-bindings.zsh"
  # dl"https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh -> key-bindings.zsh"
zinit light junegunn/fzf

# theme
zinit ice wait"!" lucid
zinit snippet OMZ::themes/ys.zsh-theme

# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure

################################################################################
# custom

alias vi=nvim
alias stu="systemctl status"
alias sta="systemctl start"
alias sto="systemctl stop"
alias str="systemctl restart"
alias ste="systemctl enable"
alias std="systemctl disable"
# alias tt="tldr -t ocean"
alias tt="tldr"
alias pa="sudo pacman"
# alias cp="cp -i"
# alias mv="mv -i"
alias rm="trash"

# set proxy
alias vpn="export http_proxy=http://127.0.0.1:7890 && export https_proxy=http://127.0.0.1:7890 && export all_proxy=http://127.0.0.1:7890"
alias vst="$HOME/myScript/proxy.sh"
alias ved="$HOME/myScript/proxy.sh ed"

alias bw="bwrap --unshare-all --share-net --die-with-parent --ro-bind / / \
  --tmpfs /sys --tmpfs /tmp --tmpfs /run --proc /proc --dev /dev \
  --ro-bind ~/.local/share/fonts ~/.local/share/fonts \
  --ro-bind ~/.config/fontconfig ~/.config/fontconfig \
  --bind ~/.cache/fontconfig ~/.cache/fontconfig --ro-bind ~/.Xauthority ~/.Xauthority \
  --ro-bind /tmp/.X11-unix /tmp/.X11-unix --ro-bind /run/user/$UID/bus /run/user/$UID/bus \
  --tmpfs /home --chdir $HOME"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
condaInit(){
__conda_setup="$('/opt/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
}
# <<< conda initialize <<<
