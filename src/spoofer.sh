#!/usr/bin/env sh

main()
{
        SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | awk -F' SSID: '  '/ SSID: / {print $2}')
        RANDOMISED_MAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
        INTERFACE=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
        echo "$SSID" "$RANDOMISED_MAC" "$INTERFACE"
        networksetup -setairportpower en0 on
        $SUDO /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport "$INTERFACE" -z
        $SUDO ifconfig "$INTERFACE" ether "$RANDOMISED_MAC"
        networksetup -detectnewhardware
        networksetup -setairportnetwork "$INTERFACE" "$SSID"

}
if [ "$(command -v doas)" ]; then
    SUDO=doas
else 
    SUDO=sudo
fi
if [ "$1" = "-c" ]; then
    while true; do
        main
        sleep $(( 60*$2 ))
    done
elif [ "$1" = "-s" ]; then
    n=0
    while [ "$n" -le "$3" ]; do
        main
        sleep $(( 60*$2 ))
        n=$(( n+1 ))
    done
else
    main
fi
