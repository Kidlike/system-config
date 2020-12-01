#!/bin/bash

echo '>> Installing NordVpn'
curl -sSL -o /tmp/nordvpn-repo.rpm https://repo.nordvpn.com/yum/nordvpn/centos/noarch/Packages/n/nordvpn-release-1.0.0-1.noarch.rpm
sudo dnf install -y /tmp/nordvpn-repo.rpm
sudo dnf update
sudo dnf install -y nordvpn

