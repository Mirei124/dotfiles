#!/bin/bash

if [ $# -ge 1 ]; then
    if [ $1 == "on" ]; then
        tee /proc/acpi/call <<<"\_SB.PCI0.GPP0.PG00._ON" && cat /proc/acpi/call
    fi
else
        tee /proc/acpi/call <<<'\_SB.PCI0.GPP0.PG00._OFF' && cat /proc/acpi/call
fi
