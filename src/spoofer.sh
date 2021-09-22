#!/usr/bin/env sh
main()
{
        SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | awk -F' SSID: '  '/ SSID: / {print $2}')
        RANDOMISED_MAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
        INTERFACE=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
        echo "$SSID" "$RANDOMISED_MAC" "$INTERFACE"
        sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport "$INTERFACE" -z
        sudo ifconfig $INTERFACE ether "$RANDOMISED_MAC"
        networksetup -setairportnetwork "$INTERFACE" "$SSID"
}
main

