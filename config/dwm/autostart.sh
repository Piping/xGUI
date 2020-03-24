export DISPLAY=:0
#wallpaper
nitrogen --restore &
#extra key binding
pkill sxhkd
sxhkd 2>&1 >/dev/null &
#status bar
while true; do
    xsetroot -name "$(date)"
    sleep 1
done &
