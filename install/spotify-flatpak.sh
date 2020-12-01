#!/bin/bash

WD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FLATPACK_PACKAGE=com.spotify.Client

command -v xdpyinfo >/dev/null 2>&1
if [ $? -ne 0 ]; then
        echo "Required dependency not found: \`xdpyinfo'"
        exit 1
fi

sudo dnf install -y flatpak xdg-desktop-portal-gtk xdg-desktop-portal

flatpak info ${FLATPACK_PACKAGE} >/dev/null
if [ $? -ne 0 ]; then
	flatpak install -y --from https://flathub.org/repo/appstream/${FLATPACK_PACKAGE}.flatpakref
fi

DESKTOP_FILE="/var/lib/flatpak/exports/share/applications/${FLATPACK_PACKAGE}.desktop"
resolutionY=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d\x -f2)
if [ $resolutionY -eq 2160 -a $(grep -c '\--force-device-scale-factor' $DESKTOP_FILE) -eq 0 ]; then
	sudo sed -i 's/^Exec=\(.*\) @@u %U @@/Exec=\1 --force-device-scale-factor=2 @@u %U @@/g' $DESKTOP_FILE
fi

