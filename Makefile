bootstrap:
	sudo apt install -y curl git
	sudo apt install -y build-essential libx11-dev xorg-dev
	sudo apt install -y sxhkd i3lock rofi

dwn:
	cd dwm/ && sudo make install
	mkdir -p ~/.config/dwm
	cp -r config/dwm ~/.config/

sxhkd:
	mkdir -p ~/.config/sxhkd/
	cp -r config/sxhkd ~/.config/

rofi:
	mkdir -p ~/.config/rofi/
	cp -r config/rofi/ ~/.config/

install: dwn sxhkd rofi

sync:
	# cp -r ~/.confid/rofi config/
	cp -r ~/.config/sxhkd config/
	cp -r ~/.config/dwm config/
