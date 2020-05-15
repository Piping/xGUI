#!/bin/bash
set -e

bootstrap() {
	sudo apt install -y curl git
	sudo apt install -y build-essential libx11-dev xorg-dev
	sudo apt install -y sxhkd i3lock rofi xwallpaper scrot feh zathura{,-ps,-cb,-djvu}
    # xvkbd -text hello
	sudo apt install -y xvkbd
}

dwn() {
	cd dwm/ && sudo make install
	mkdir -p ~/.config/dwm
	cp -r config/dwm ~/.config/
}

sxhkd() {
	mkdir -p ~/.config/sxhkd/
	cp -r config/sxhkd ~/.config/
}

rofi() {
	mkdir -p ~/.config/rofi/
	cp -r config/rofi/ ~/.config/
}

install() {
    dwn
    sxhkd
    rofi
}

sync() {
	# cp -r ~/.confid/rofi config/
	cp -r ~/.config/sxhkd config/
	cp -r ~/.config/dwm config/
}

kvm-bootstrap() {
	sudo apt install qemu qemu-system virt-manager ebtables
	sudo systemctl enable --now libvirtd
	sudo usermod -G libvirtd -a robin
}

kvm-convert() {
	sudo qemu-img convert -f vid -O "${DISK}" "/var/lib/libvirt/images/${DISK}.qcow2"
}

font() {
	git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
	cd nerd-fonts && chmod +x install.sh && sudo ./install.sh -S
}

cli-visualizer() {
    sudo apt install libfftw3-dev libncursesw5-dev cmake libpulse-dev
    git clone https://github.com/dpayne/cli-visualizer.git && cd cli-visualizer && ./install.sh
}

"$@"
