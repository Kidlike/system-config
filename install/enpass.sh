#!/bin/bash

INSTALL_DIR="/opt/enpass"
TMP_DIR=${HOME}/.cache/install-enpass

function installDependencies() {
    echo ">> Installing dependencies for Enpass"
    sudo dnf install libXScrnSaver lsof xdotool xmlstarlet
}

function getVersion() {
    local releaseNotesHtml=$(mktemp)
    curl -sSL https://www.enpass.io/release-notes/linux/ -o ${releaseNotesHtml}
    xmlstarlet fo -H -R -Q ${releaseNotesHtml} | \
        xmlstarlet sel -t -m "//h3[contains(text(), 'Version')][1]" -v '.' | \
        sed 's/Version //'
    rm ${releaseNotesHtml} 2>/dev/null
}

function downloadEnpass() {
    local versionDots=${1:?Please provide which version to download}
    local versionDashes=$(echo $versionDots | tr '.' '-')
    local filename="enpass-${versionDots}-installer"

    mkdir -p ${TMP_DIR} 2>/dev/null
    cd ${TMP_DIR}

    if [ ! -r ${filename} ]; then
        curl -sSL --header "Referer: https://www.enpass.io/download-enpass-linux/" \
            "https://dl.sinew.in/linux/setup/${versionDashes}/Enpass_Installer_${versionDots}" \
            -o ${filename}
        chmod +x ${filename}
    fi

    cd - >/dev/null
}

function waitForWindow() {
    local title=${1:?Please provide the title of the window you are waiting for}
    while true; do
        local windowId=$(xdotool search --name "${title}")
        if [ -n "${windowId}" ]; then
            break
        fi
        sleep 1
    done
    echo "${windowId}"
}

function installEnpass () {
    local version=${1:?Please provide which version to download}
    sudo rm -rf "${INSTALL_DIR}" 2>/dev/null
    sudo mkdir -p ${INSTALL_DIR} 2>/dev/null

    ./enpass-${version}-installer &
    local pid=$!

    # wait for window
    local windowId=$(waitForWindow "Enpass Setup")
    sleep 0.5
    xdotool windowactivate ${windowId}
    sleep 0.5

    xdotool key "alt+n" # next
    sleep 0.5

    # change install dir
    xdotool key "ctrl+a"
    sleep 0.5
    xdotool type "${INSTALL_DIR}"
    sleep 0.5

    xdotool key "alt+n" # next
    sleep 0.5
    xdotool key "alt+n" # next
    sleep 0.5
    xdotool key "alt+a" # accept T&C
    sleep 0.5
    xdotool key "alt+n" # next
    sleep 0.5
    xdotool key "alt+i" # install

    # wait for authorization
    while true; do
        sleep 1
        xdotool search --name "Authorization required" >/dev/null 2>&1
        [ $? -eq 1 ] && break
    done

    # wait for installation
    while true; do
        sleep 1
        ps $pid >/dev/null 2>&1
        [ $? -eq 1 ] && break
        xdotool key "alt+f" # finish
    done

    echo "done"
}

function configureEnpass() {
    local lineNumber=$(grep -n '/Enpass ' ${INSTALL_DIR}/runenpass.sh | cut -d\: -f1)
    sudo sed -e "${lineNumber}iexport QT_AUTO_SCREEN_SCALE_FACTOR=1" -i ${INSTALL_DIR}/runenpass.sh
}

function cleanup() {
    local version=${1:?Please provide which version to download}
    find ${TMP_DIR} -type f ! -name "*${version}*" -delete
}

installDependencies
enpassVersion=$(getVersion)
downloadEnpass "${enpassVersion}"
installEnpass "${enpassVersion}"
configureEnpass
cleanup "${enpassVersion}"

