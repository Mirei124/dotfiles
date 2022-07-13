#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/archcraft"

fixModule() {
    # card="$(ls /sys/class/backlight | grep amd)"
    card=$(find /sys/class/backlight -name "amdgpu*" | cut -d"/" -f 5)
    sed -ri "s/^graphics_card = .*/graphics_card = ${card}/" "${DIR}"/system.ini
}

polybarStart() {
    # Terminate already running bar instances
    killall -q polybar
    # polybar-msg cmd quit

    # Wait until the processes have been shut down
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

    # Launch the bar
    polybar -q main -c "${DIR}"/config.ini &
}

fixModule
polybarStart
