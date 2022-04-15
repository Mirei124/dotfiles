#!/bin/sh
cd /home/k/myScript/careEye
pgrep -f care_eye || python care_eye.py &
