#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

## Launch

polybar vpn_status -c ~/.config/polybar/config-primary.ini & 
polybar cpu -c ~/.config/polybar/config-primary.ini & 
polybar file_system -c ~/.config/polybar/config-primary.ini & 
polybar bspwm_envs -c ~/.config/polybar/config-primary.ini &
polybar date -c ~/.config/polybar/config-primary.ini &

sleep 0.5
polybar principal_bar -c ~/.config/polybar/config-primary.ini &  
