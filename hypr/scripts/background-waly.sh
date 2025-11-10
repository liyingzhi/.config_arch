#!/bin/sh

sleep 10
battery=`acpi`
power_plug="Discharging"

if [[ $battery =~ $power_plug ]]
then
    lastplug=true
    echo "没有接入电源, 使用壁纸"
    pkill mpvpaper
    ~/.config/hypr/scripts/background-static.sh &
else
    lastplug=false
    echo "接入电源, 开启动态壁纸"
    # mpvpaper "*" ~/Videos/灵梦.mp4 -o "--loop-file=inf" &
    ~/.config/hypr/scripts/background-video.sh &
fi
