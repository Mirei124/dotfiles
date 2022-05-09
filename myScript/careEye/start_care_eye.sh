#!/bin/sh
pgrep -f care_eye.py || python $HOME/myScript/careEye/care_eye.py &
