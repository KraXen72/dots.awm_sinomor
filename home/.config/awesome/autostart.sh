#! /bin/bash

$HOME/.config/awesome/other/picom/launch.sh --opacity &
feh --no-fehbg --bg-fill $HOME/.config/awesome/themes/wall.jpg &
pgrep -x cycle_wall > /dev/null || cycle_wall 30m &
pgrep -x polkit-gnome-au > /dev/null || /usr/libexec/polkit-gnome-authentication-agent-1 &
pgrep -x greenclip > /dev/null || greenclip daemon &
pgrep -x nm-applet > /dev/null || nm-applet --indicator 
