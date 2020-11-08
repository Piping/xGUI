terminal() {
    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
}

ubuntu() {
    #for ubuntu server 20.04 minimal
    sudo apt install git tmux vim curl -y
    sudo apt install xinit
    sudo apt install x11-xserver-utils xwallpaper
    sudo apt install fonts-noto-cjk-extra
    sudo apt install herbstluftwm --no-install-recommends --no-install-suggests
    sudo apt install firefox --no-install-suggests --no-install-recommends
    sudo apt install ffmpeg
    sudo apt install pulseaudio pavucontrol
    sudo apt autoremove --purge snapd
    sudo apt remove --purge unattended-upgrades

    sudo apt-get install ifupdown
    sudo systemctl disable --now systemd-networkd.socket systemd-networkd networkd-dispatcher systemd-networkd-wait-online
    sudo apt autoremove --purge netplan.io
    sudo rm -fr /etc/netplan
    sudo rm -fr /etc/resolv.conf
    sudo rm /etc/dhcp/dhclient-enter-hooks.d/resolved
    cat <<EOF | sudo tee /etc/resolv.conf
nameserver 8.8.8.8
EOF
    cat <<EOF | sudo tee /etc/network/interfaces
allow-hotplug wlp5s0
iface wlp5s0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOF
    # edit the file to change wpa_supplicant cmds
    cat <<EOF | sudo tee /etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
[]
Description=WPA supplicant
Before=network.target
After=dbus.service
Wants=network.target
IgnoreOnIsolate=true

[Service]
Type=forking
BusName=fi.w1.wpa_supplicant1
ExecStart=/sbin/wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlp5s0 -B

[Install]
WantedBy=multi-user.target
Alias=dbus-fi.w1.wpa_supplicant1.service
EOF
    # some common task want to be executed
    cat <<EOF | sudo tee /etc/systemd/system/my-startup.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/libexec/my-startup-script

[Install]
WantedBy=multi-user.target
EOF
    cat <<EOF | sudo tee /usr/local/libexec/my-startup-script
setfont /usr/share/consolefonts/CyrAsia-TerminusBold32x16.psf.gz
EOF
    # disable multipathd for network disks
    sudo systemctl disable --now multipathd
    # disable unused services
    sudo apt autoremove accountsservice
    sudo systemctl disable --now accounts-daemon
    # reconfigure console fonts beside using setfont
    sudo dpkg-reconfigure console-setup

    # now install input method for chinese and other languages
    sudo apt install fcitx-ui-classic/focal --no-install-suggests --no-install-recommends
    sudo apt install fcitx-libpinyin --no-install-suggests --no-install-recommends
    sed -i 's/IMName=.*/IMName=pinyin-libpinyin/' ~/.config/fcitx/profile
    # required by gtk2/3, qt5, fbterm, firefox and other gui programs
    sudo apt install fcitx-module-dbus fcitx-frontend-all
}

setup() {
    sudo_apt
    term
}

void() {
    sudo xbps-install -S
    sudo xbps-install git tmux curl aria2 wget

    ln -s /etc/sv/dbus /var/service/dbus
    sv start dbus

    ln -s /etc/sv/alsa /var/service/alsa
    sv start alsa

    ln -s /etc/sv/wpa_supplicant /var/service/wpa_supplicant
    sv start wpa_supplicant
    # wpa_cli
    # add_network 0
    # set_network 0 ssid "name"
    # set_network 0 password 123456
    # enable_network 0

    sudo xbps-install noto-fonts-cjk nerd-fonts
    ln -s /usr/share/fontconfig/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d/
    ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
    ln -s /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
    ln -s /usr/share/fontconfig/conf.avail/50-user.conf /etc/fonts/conf.d/
    ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

    #cjk input method
    sudo xbps-install fcitx fcitx-libpinyin
    sudo xbps-install libfcitx-gtk libfcitx-gtk3 libfcitx-qt libfcitx-qt5

    #browser codec mp4 etc
    sudo xbps-install firefox gst-libav
}

void_console() {
   # /usr/share/kbd/consolefonts/solar24x32.psfu.gz
   setfont solar24x32.psfu.gz
   # swap escape and caps_lock for console
   dumpkeys | sed s/Caps_Lock/Escape/ | loadkeys

   # edit /etc/rc.conf to modify console settings and make the change persistent
   # additional, set fbterm to allow unicode and input method to be used
}

android() {
    git clone https://github.com/M0Rf30/android-udev-rules.git
    cd android-udev-rules/
    sudo cp 51-android.rules /usr/lib/udev/rules.d/
    sudo chmod a+r /usr/lib/udev/rules.d/51-android.rules
    sudo groupadd adbusers
    sudo usermod -a -G adbusers robin
    sudo udevadm control --reload-rules
    sudo xi -S android-tools
    adb devices
    # copy file over
    # adb push file /sdcard/directory
    # adb shell
    # adb shell <commands>
}

virt() {
    sudo xi virt-manager libvirt qemu
    sudo usermod -aG kvm robin
    sudo modprobe kvm-amd
    sudo gpasswd -a robin libvirt
    sudo ln -s /etc/sv/libvirtd /var/service
    sudo ln -s /etc/sv/virtlogd/ /var/service
    sudo ln -s /etc/sv/virtlockd/ /var/service
    virt-manager
    # for void with GPU passthrough
    # set iommu and pci.ids on kernel cmdline through update-grub
    # amd_iommu=on iommu=pt vfio-pci.ids=1002:731f,1002:ab38
    # for void initramfs, vfio-pci was built as kernel module
    cat > /etc/dracut.conf.d/vfio.conf <<-EOF
    hostonly="yes"
    hostonly_cmdline="amd_iommu=on iommu=pt"
    force_drivers+="vfio_pci vfio vfio_iommu_type1 vfio_virqfd"
EOF
    uname -r
    sudo xbps-reconfigure --force linux5.8
    sudo dmesg | grep -i vfio
}


win_iso() {
  curl  --location  --remote-name  --remote-header-name https://github.com/WoeUSB/WoeUSB/raw/master/sbin/woeusb
  chmod +x woeusb
  sudo xi ntfs-3g wget parted
  ./woeusb --help
  lsblk
  sudo ./woeusb --target-filesystem NTFS -d Win10_20H2_Chinese\(Simplified\)_x64.iso /dev/sdb
}

"$@"
