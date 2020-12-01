#!/bin/bash

echo '>> Installing lpf-spotify-client'
sudo dnf install lpf-spotify-client
lpf update

# According to `man lpf' the only thing needed is `lpf update'. Making the bellow commands obsolete
# lpf approve spotify-client
# sudo -u pkg-build lpf build spotify-client 
# sudo dnf install /var/lib/lpf/rpms/spotify-client/spotify-client-*.rpm

# remove this desktop entry as it's annoying and useless.
sudo rm /usr/share/applications/lpf-spotify-client.desktop 2>/dev/null
