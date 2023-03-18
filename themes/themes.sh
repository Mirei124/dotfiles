#!/bin/bash

sdir="$HOME"/themes

function uninstall() {
	echo 'uninstalling Layan-cursors...'
	rm -rf "$HOME"/.local/share/icons/Layan-cursors
	rm -rf "$HOME"/.local/share/icons/Layan-border-cursors
	rm -rf "$HOME"/.local/share/icons/Layan-white-cursors

	echo 'uninstalling Layan-kde...'
	"$HOME"/themes/Layan-kde/uninstall.sh

	echo 'uninstalling Tela-icon-theme...'
	rm -rf "$HOME"/.local/share/icons/Tela*

	echo 'uninstalling Layan-gtk-theme...'
	rm -rf "$HOME"/.themes/Layan*

	echo 'uninstalling Fluent-gtk-theme...'
	rm -rf "$HOME"/.themes/Fluent*
}

function update() {
	for loop in $(ls -d */); do
		cat <<EOF
updating... $loop
EOF
		cd "$loop" || exit
		git pull
		cd "$sdir" || exit
	done
}

function install() {
	# echo 'installing kwin-tiling...'
	# cd ./kwin-tiling || exit
	# plasmapkg2 --type kwinscript -u .
	# cd $sdir || exit

	echo 'installing Layan-cursors...'
	cd ./Layan-cursors || exit
	./install.sh
	cd "$sdir" || exit

	echo 'installing Layan-kde...'
	cd ./Layan-kde || exit
	./install.sh
	cd "$sdir" || exit

	# echo 'installing Layan-gtk-theme...'
	# cd ./Layan-gtk-theme || exit
	# ./install.sh
	# cd "$sdir" || exit

	# echo 'installing Fluent-gtk-theme...'
	# cd ./Fluent-gtk-theme || exit
	# ./install.sh
	# cd "$sdir" || exit

	echo 'installing icon...'
	cd ./Tela-icon-theme || exit
	./install.sh
	cd "$sdir" || exit
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
