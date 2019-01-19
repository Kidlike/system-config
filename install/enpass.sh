#!/bin/bash

echo ">> Adding Enpass RPM repository"
sudo wget https://yum.enpass.io/enpass-yum.repo -O /etc/yum.repos.d/enpass.repo
sudo dnf install enpass

