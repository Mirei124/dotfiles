#!/bin/bash

card="$(ls /sys/class/backlight)"
sed -ri "s/^card = .*/card = $card/" $HOME/.config/polybar/forest/modules.ini
