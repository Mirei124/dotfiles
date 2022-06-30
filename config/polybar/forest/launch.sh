#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/forest"

fixModule() {
    card="$(ls /sys/class/backlight | grep amd)"
    sed -ri "s/^card = .*/card = $card/" $HOME/.config/polybar/forest/modules.ini
}

polybarStart() {
    # Terminate already running bar instances
    killall -q polybar
    # polybar-msg cmd quit

    # Wait until the processes have been shut down
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

    # Launch the bar
    polybar -q main -c "$DIR"/config.ini &
}

fixModule
polybarStart
