#!/bin/bash

FLATPACK_PACKAGE=com.uploadedlobster.peek

echo '>> Installing peek (gif recorder)'

sudo dnf install -y flatpak xdg-desktop-portal-gtk

flatpak info ${FLATPACK_PACKAGE} >/dev/null
if [ $? -ne 0 ]; then
	flatpak install -y flathub ${FLATPACK_PACKAGE}
fi

