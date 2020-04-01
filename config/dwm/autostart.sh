## Autostart ##
export DISPLAY=:0
#wallpaper
xwallpaper --zoom /usr/share/backgrounds/Flight_dive_by_Nicolas_Silva.png
#extra key binding
pkill sxhkd
sxhkd >& /dev/null &
#status bar
input_method() {
    if [ $(ibus engine) == "libpinyin" ]; then
        echo -n "Zh"
    else
        echo -n "En"
    fi
}
while true; do
    xsetroot -name "$(input_method) | $(date)"
    read -t 1
done &
