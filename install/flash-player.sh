#!/bin/bash

set -eux

BASEARCH=x86_64

echo '>> Installing Adobe Flash Player'
rpm -q adobe-release-x86_64-1.0-1.noarch >/dev/null 2>&1
if [ $? -ne 0 ]; then
	sudo rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-${BASEARCH}-1.0-1.noarch.rpm
fi
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
sudo dnf install -y flash-plugin alsa-plugins-pulseaudio libcurl

