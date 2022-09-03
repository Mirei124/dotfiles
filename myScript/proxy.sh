#!/bin/bash

function start() {
	echo "Start clash..."
    nohup /opt/clash-for-windows-bin/cfw >/dev/null 2>&1 &
	echo "Enable system proxy..."
	kwriteconfig5 --file $HOME/.config/kioslaverc --group "Proxy Settings" --key "ProxyType" 1
	echo -e "\033[32mDone\033[0m"
}

function stop() {
	echo "Disable system proxy..."
	kwriteconfig5 --file $HOME/.config/kioslaverc --group "Proxy Settings" --key "ProxyType" 0
    echo "Stop clash..."
    pgrep cfw | xargs kill -9
	echo -e "\033[32mDone\033[0m"
}

if [ $# -ge 1 ]; then
	if [ $1 = "ed" ]; then
		stop
	fi
else
	start
fi
