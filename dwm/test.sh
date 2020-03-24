Xephyr -dpi 192 -screen 1440x900 :1 &
sleep 0.5
DISPLAY=:1 /usr/bin/bspwm &

