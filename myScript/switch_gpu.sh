#!/bin/bash

if [ $# -ge 1 ]; then
    if [ $1 == "on" ]; then
        echo "on"
        echo "\_SB.PCI0.GPP0.PG00._ON" > /proc/acpi/call && cat /proc/acpi/call
    fi
else
    echo "\_SB.PCI0.GPP0.PG00._OFF" > /proc/acpi/call && cat /proc/acpi/call
fi
