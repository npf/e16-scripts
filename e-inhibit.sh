#!/bin/bash
STAMP=/tmp/e-inhibit
if [ ! -e $STAMP ]; then
	dconf write /org/gnome/desktop/screensaver/idle-activation-enabled false
	dconf write /org/gnome/settings-daemon/plugins/power/active false
	zenity --notification --text="Power saving feature inhibited" --title="Inhibit" --window-icon="info" --timeout=1
	touch $STAMP
else
	dconf reset /org/gnome/desktop/screensaver/idle-activation-enabled true
	dconf reset /org/gnome/settings-daemon/plugins/power/active true
	zenity --notification --text="Power saving feature reset" --title="Inhibit" --window-icon="info" --timeout=1
	rm $STAMP
fi
