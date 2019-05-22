#!/bin/bash

set -eu

PARSEC_INSTALLER="parsec-fedora.sh"
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

echo ">> Downloading Parsec installer"
curl -sSL https://github.com/Kozova1/parsec-fedora/raw/master/parsec-fedora -o ${PARSEC_INSTALLER}
chmod u+x ${PARSEC_INSTALLER}

echo ">> Executing Parsec installer"
./${PARSEC_INSTALLER}

rm -rf ${TEMP_DIR}

