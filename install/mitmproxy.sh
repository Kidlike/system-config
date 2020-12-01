#!/bin/bash

WD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INST_DIR=/opt/mitmproxy
TMP_DIR=${HOME}/.cache/install-mitmproxy-latest

# find latest version
mkdir "$TMP_DIR" 2>/dev/null
cd "$TMP_DIR"
echo '>> [mitmproxy] Detecting new versions...'
curl -sSL 'https://s3-us-west-2.amazonaws.com/snapshots.mitmproxy.org?delimiter=/' -o mitm-versions.xml
version=$(xmlstarlet sel -t -m "//_:Prefix" -v . -n mitm-versions.xml  | awk -F '/' '{print $1}' | grep -E '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1)
packageName="mitmproxy-${version}-linux.tar.gz"

if [ ! -r "$packageName" ]; then
	rm -rf *
	echo ">> [mitmproxy] Downloading new version ${version}..."
	curl -sSL https://snapshots.mitmproxy.org/${version}/${packageName} -o ${packageName}
fi

echo ">> [mitmproxy] Installing..."
sudo mkdir -p "${INST_DIR}" 2>/dev/null
sudo tar --directory="${INST_DIR}" -xf ${packageName}
for f in `\ls -1 ${INST_DIR}`; do
	sudo ln -sf ${INST_DIR}/$f /opt/share/bin/$f
done

echo '>> [mitmproxy] To install the custom CA copy the pem file to /usr/share/pki/ca-trust-source/anchors/'
echo
