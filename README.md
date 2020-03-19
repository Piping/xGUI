# My dwm (Dynamic Window Manager) build

![Screenshot of my desktop](https://gitlab.com/dwt1/dotfiles/raw/master/.screenshots/dotfiles04.png) 
Dwm is an extremely fast, small, and dynamic window manager for X.  This is my personal build of dwm.  I used a number of patches in this build to make dwm more "sensible" rather than "suckless."  The patches I added to this build include:
+ alpha (for transparency)
+ attachaside (new clients appear in the stack rather than as the master)
+ cyclelayouts (cycles through the available layouts)
+ gridmode (adding a grid layout)
+ restartsig (allows dwm to be restarted with a keybinding)
+ rotatestack (moves a window through the stack, in either direction)
+ statuspadding (horizontal and vertical padding in the status bar are now configurable options)
+ uselessgap (adding gaps when more than one window)

# My Keybindings

The MODKEY is set to the Super key (aka the Windows key).  I try to keep the
keybindings consistent with all of my window managers.

| Keybinding | Action |
| :--- | :--- |
| `MODKEY + RETURN` | opens terminal (alacritty is the terminal but can be easily changed) |
| `MODKEY + SHIFT + RETURN` | opens run launcher (dmenu is the run launcher but can be easily changed) |
| `MODKEY + SHIFT + c` | closes window with focus |
| `MODKEY + SHIFT + r` | restarts dwm |
| `MODKEY + SHIFT + q` | quits dwm |
| `MODKEY + 1-9` | switch focus to workspace (1-9) |
| `MODKEY + SHIFT + 1-9` | send focused window to workspace (1-9) |
| `MODKEY + j` | focus stack +1 (switches focus between windows in the stack) |
| `MODKEY + k` | focus stack -1 (switches focus between windows in the stack) |
| `MODKEY + SHIFT + j` | rotate stack +1 (rotates the windows in the stack) |
| `MODKEY + SHIFT + k` | rotate stack -1 (rotates the windows in the stack) |
| `MODKEY + h` | setmfact -0.05 (expands size of window) |
| `MODKEY + l` | setmfact +0.05 (shrinks size of window) |
| `MODKEY + .` | focusmon +1 (switches focus next monitors) |
| `MODKEY + ,` | focusmon -1 (switches focus to prev monitors) |

Afterwards enter the following command to build and install dwm :

    sudo make clean install


# Running dwm

If you do not use a login manager (like lightdm) then you can add the following line to your .xinitrc to start dwm using startx:

    exec dwm
	
If you use a login manager, make sure that you have a file called dwm.desktop in your /usr/share/xsessions/ directory.  It should look something like this:

	[Desktop Entry]
	Encoding=UTF-8
	Name=Dwm
	Comment=Dynamic window manager
	Exec=dwm
	Icon=dwm
	Type=XSession


In order to connect dwm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

    DISPLAY=foo.bar:1 exec dwm

(This will start dwm on display :1 of the host foo.bar.)

In order to display status info in the bar, you can do something
like this in your .xinitrc:

    while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
    do
    	sleep 1
    done &
    exec dwm


# Configuration

The configuration of dwm is done by creating a custom config.h
and (re)compiling the source code:

	sudo make install