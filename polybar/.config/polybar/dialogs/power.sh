#!/bin/bash

YAD_WIDTH=300
Y_OFFSET=40
X_OFFSET=-10
TITLE="System Logout"
TIMEOUT=10


eval "$(xdotool getmouselocation --shell)"
: $(( pos_x = X - YAD_WIDTH - $X_OFFSET ))

# default to always displaying just below the top bar
pos_y=$Y_OFFSET

if xdotool search --name "$TITLE" search --class yad getwindowpid &>/dev/null; then
    exit 0
fi

action=$(yad --width $YAD_WIDTH --entry --title "$TITLE" \
    --posx=$pos_x --posy=$pos_y \
    --image=gnome-shutdown \
    --button="Cancel!gtk-close:1" \
    --button="Confirm!gtk-ok:0" \
    --text "Choose action:" \
    --entry-text \
    "Power Off" "Reboot" "Suspend" "Logout")
ret=$?

[[ $ret -eq 1 ]] && exit 0

case $action in
    Power*)
        text="Powering off..."
        btntext="Power off now"
        cmd="sudo /sbin/poweroff"
        ;;
    Reboot*)
        text="Rebooting..."
        btntext="Reboot now"
        cmd="sudo /sbin/reboot"
        ;;
    Suspend*)
        text="Suspending..."
        btntext="Suspend now"
        cmd="sudo /bin/sh -c 'echo disk > /sys/power/state'"
        ;;
    Logout*)
        text="Logging out..."
        btntext="Logout now"
        case $(wmctrl -m | grep Name) in
            *Openbox) cmd="openbox --exit" ;;
            *FVWM) cmd="FvwmCommand Quit" ;;
            *Metacity) cmd="gnome-save-session --kill" ;;
            *i3) cmd="i3-msg exit" ;;
            *) exit 1 ;;
        esac
        ;;
    *) exit 1 ;;
esac


countdown=$(yad --center --on-top --borders=5 \
    --timeout=$TIMEOUT --timeout-indicator=top \
    --text="$text" --text-align=center \
    --button="Cancel!gtk-close:1" \
    --button="$btntext!gtk-ok:0")
ret=$?

if [ $ret -eq 0 -o $ret -eq 70 ]; then
    eval exec $cmd
fi

exit 1
