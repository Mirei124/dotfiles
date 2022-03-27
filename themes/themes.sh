#!/bin/bash
sdir=$HOME/themes

function uninstall() {
    rm -rf $HOME/.local/share/icons/Layan-cursors
    rm -rf $HOME/.local/share/icons/Layan-border-cursors
    rm -rf $HOME/.local/share/icons/Layan-white-cursors

    $HOME/themes/Layan-kde/uninstall.sh

    rm -rf $HOME/.local/share/icons/Tela*
}

function update() {
    for loop in $(ls -d */); do
        cat <<EOF
updating... $loop
EOF
        cd $loop
        git pull
        cd $sdir
    done
}

function install() {
    echo 'installing tiling...'
    cd ./kwin-tiling
    plasmapkg2 --type kwinscript -u .
    cd $sdir

    echo 'installing cursors...'
    cd ./Layan-cursors
    ./install.sh
    cd $sdir

    echo 'installing kde theme...'
    cd ./Layan-kde
    ./install.sh
    cd $sdir

    echo 'installing icon...'
    cd ./Tela-icon-theme
    ./install.sh
    cd $sdir
}

if [[ $# -ge 1 ]]; then
    if [[ $1 = 'update' ]]; then
        update
    elif [[ $1 = 'uninstall' ]]; then
        uninstall
    elif [[ $1 = 'install' ]]; then
        install
    fi
else
    cat <<EOF
$0 [option] install uninstall update
EOF
fi
